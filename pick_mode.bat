<# 2>nul
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~f0" %*
exit /b %errorlevel%
#>

param([Parameter(ValueFromRemainingArguments=$true)][string[]]$QueryParts = @())
$Query = ($QueryParts -join " ").Trim()

# ── Config ───────────────────────────────────────────────
$SERVER_IP     = "127.0.0.1"
$SERVER_PORT   = 27015
$RCON_PASSWORD = "alroker"

# Path to the L4D2 server's LIVE cfg folder (where the server reads/execs
# .cfg files, e.g. ...\left4dead2\cfg). The picker discovers modes here AND
# writes "current_mode.cfg" here so the selected mode persists across
# chapters (server.cfg re-execs `current_mode` on every map load).
# Leave "" to use the cfg\ folder next to this script.
$SERVER_CFG_DIR = "C:\path\to\left4dead2\cfg"
# ─────────────────────────────────────────────────────────

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($SERVER_CFG_DIR)) {
    $CFG_DIR = Join-Path $SCRIPT_DIR "cfg"
} else {
    $CFG_DIR = $SERVER_CFG_DIR
}

if (-not (Test-Path -LiteralPath $CFG_DIR)) {
    Write-Host ""
    Write-Host "  cfg folder not found:" -ForegroundColor Red
    Write-Host "    $CFG_DIR"
    Write-Host "  Set `$SERVER_CFG_DIR at the top of this script." -ForegroundColor Yellow
    Write-Host ""
    pause; exit 1
}

# ── Auto-discover modes ──────────────────────────────────
# Any mode_*.cfg in the cfg folder is a playable mode. reset.cfg and
# current_mode.cfg are excluded by the glob. Display name is read from each
# file's `echo [MODE] <Name> loaded` line, so adding a mode = dropping in a
# new cfg. No edits to this script.
$Modes = @(
    Get-ChildItem -Path $CFG_DIR -Filter "mode_*.cfg" -File -ErrorAction SilentlyContinue |
        Sort-Object Name |
        ForEach-Object {
            $stem = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
            $name = $stem -replace '^mode_', ''
            $m = Select-String -Path $_.FullName -Pattern '\[MODE\]\s+(.+?)\s+loaded' |
                 Select-Object -First 1
            if ($m) { $name = $m.Matches[0].Groups[1].Value }
            [PSCustomObject]@{ Name = $name; File = $stem }
        }
)
$ModeCount = $Modes.Count

if ($ModeCount -eq 0) {
    Write-Host ""
    Write-Host "  No mode_*.cfg files found in:" -ForegroundColor Red
    Write-Host "    $CFG_DIR"
    Write-Host ""
    pause; exit 1
}

# ── Resolve selection -> $modeFile (exec target) + $modeLabel ────
$modeFile  = $null
$modeLabel = $null

if ($Query -match '^(reset|vanilla)$') {
    # Reset must also clear the persisted mode, otherwise server.cfg would
    # re-apply the previous mode on the next chapter.
    $modeFile  = "reset"
    $modeLabel = "[RESET] Vanilla Reset"

} else {
    $modeNum = $null

    if ($Query -eq "") {
        $modeNum = (Get-Random -InputObject (1..$ModeCount))

    } elseif ($Query -match '^\d+$') {
        $n = [int]$Query
        if ($n -lt 1 -or $n -gt $ModeCount) {
            Write-Host ""
            Write-Host "  Mode number must be between 1 and $ModeCount." -ForegroundColor Red
            Write-Host ""
            pause; exit 1
        }
        $modeNum = $n

    } else {
        $matchList = @()
        for ($k = 0; $k -lt $ModeCount; $k++) {
            if ($Modes[$k].Name -match [regex]::Escape($Query)) {
                $matchList += [PSCustomObject]@{ Num = $k + 1; Name = $Modes[$k].Name }
            }
        }

        if ($matchList.Count -eq 0) {
            Write-Host ""
            Write-Host "  No mode found matching '$Query'." -ForegroundColor Red
            Write-Host ""
            Write-Host "  Available modes:"
            for ($k = 0; $k -lt $ModeCount; $k++) { Write-Host "    $($k + 1): $($Modes[$k].Name)" }
            Write-Host "    (or: reset)"
            Write-Host ""
            pause; exit 1

        } elseif ($matchList.Count -eq 1) {
            $modeNum = $matchList[0].Num

        } else {
            Write-Host ""
            Write-Host "  Multiple modes match '$Query':" -ForegroundColor Yellow
            $matchList | ForEach-Object { Write-Host "    $($_.Num): $($_.Name)" }
            Write-Host ""
            $choice = Read-Host "  Enter mode number"
            if ($choice -match '^\d+$' -and [int]$choice -ge 1 -and [int]$choice -le $ModeCount) {
                $modeNum = [int]$choice
            } else {
                Write-Host "  Invalid choice." -ForegroundColor Red
                Write-Host ""
                pause; exit 1
            }
        }
    }

    $mode      = $Modes[$modeNum - 1]
    $modeFile  = $mode.File
    $modeLabel = "[MODE $modeNum] $($mode.Name)"
}

cls
Write-Host ""
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host "    L4D2 Versus Mode Picker"                  -ForegroundColor Cyan
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host ""

if ($Query -eq "") {
    Write-Host "  Rolling..." -ForegroundColor DarkGray
    Start-Sleep -Seconds 1
    Write-Host ""
}

Write-Host ("  {0}" -f $modeLabel) -ForegroundColor Green
Write-Host ""

# ── Persist selection so it survives chapter changes ─────
# server.cfg should contain `exec current_mode` (re-runs every map load).
$currentModePath = Join-Path $CFG_DIR "current_mode.cfg"
$persisted = $false
try {
    Set-Content -LiteralPath $currentModePath -Value "exec $modeFile" -Encoding ASCII -ErrorAction Stop
    $persisted = $true
} catch {
    # Non-fatal: we still apply to the current chapter via RCON below.
}

if ($persisted) {
    Write-Host "  Persisted -> next chapters will keep this mode." -ForegroundColor DarkGray
} else {
    Write-Host "  [WARN] Could not write current_mode.cfg (will apply to current chapter only)." -ForegroundColor Yellow
}
Write-Host "  Sending to server ${SERVER_IP}:${SERVER_PORT}..." -ForegroundColor DarkGray
Write-Host ""

$rconExe = Join-Path $SCRIPT_DIR "rcon.exe"
if (-not (Test-Path $rconExe)) { $rconExe = "rcon" }

& $rconExe -a "${SERVER_IP}:${SERVER_PORT}" -p $RCON_PASSWORD "exec $modeFile"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  [OK] Mode applied to current chapter." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  [WARN] rcon.exe not found or connection failed." -ForegroundColor Yellow
    Write-Host "  Manually run in server console:"
    Write-Host "    exec $modeFile" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "  To reset: pick_mode.bat reset   (or: exec reset)"
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host ""
pause
