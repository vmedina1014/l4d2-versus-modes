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
# ─────────────────────────────────────────────────────────

$Modes = [ordered]@{
    1  = "Denser Horde"
    2  = "Tougher Commons"
    3  = "Faster Commons"
    4  = "Longer Smoker Reach"
    5  = "Punchier Hunter"
    6  = "Heftier Tank"
    7  = "More Frequent Tank"
    8  = "Witch Pressure"
    9  = "Reduced Healing"
    10 = "Tighter Ammo"
}

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$modeNum    = $null

if ($Query -eq "") {
    $modeNum = Get-Random -InputObject (1..10)

} elseif ($Query -match '^\d+$') {
    $n = [int]$Query
    if ($n -lt 1 -or $n -gt 10) {
        Write-Host ""
        Write-Host "  Mode number must be between 1 and 10." -ForegroundColor Red
        Write-Host ""
        pause; exit 1
    }
    $modeNum = $n

} else {
    $matchList = @($Modes.GetEnumerator() | Where-Object { $_.Value -match [regex]::Escape($Query) })

    if ($matchList.Count -eq 0) {
        Write-Host ""
        Write-Host "  No mode found matching '$Query'." -ForegroundColor Red
        Write-Host ""
        Write-Host "  Available modes:"
        $Modes.GetEnumerator() | ForEach-Object { Write-Host "    $($_.Key): $($_.Value)" }
        Write-Host ""
        pause; exit 1

    } elseif ($matchList.Count -eq 1) {
        $modeNum = $matchList[0].Key

    } else {
        Write-Host ""
        Write-Host "  Multiple modes match '$Query':" -ForegroundColor Yellow
        $matchList | Sort-Object Key | ForEach-Object { Write-Host "    $($_.Key): $($_.Value)" }
        Write-Host ""
        $choice = Read-Host "  Enter mode number"
        if ($Modes.Contains([int]$choice)) {
            $modeNum = [int]$choice
        } else {
            Write-Host "  Invalid choice." -ForegroundColor Red
            Write-Host ""
            pause; exit 1
        }
    }
}

$modeName = $Modes[$modeNum]

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

Write-Host ("  [MODE {0}] {1}" -f $modeNum, $modeName) -ForegroundColor Green
Write-Host ""
Write-Host "  Sending to server ${SERVER_IP}:${SERVER_PORT}..." -ForegroundColor DarkGray
Write-Host ""

$rconExe = Join-Path $SCRIPT_DIR "rcon.exe"
if (-not (Test-Path $rconExe)) { $rconExe = "rcon" }

& $rconExe -a "${SERVER_IP}:${SERVER_PORT}" -p $RCON_PASSWORD "exec mode$modeNum"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  [OK] Mode applied successfully." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  [WARN] rcon.exe not found or connection failed." -ForegroundColor Yellow
    Write-Host "  Manually run in server console:"
    Write-Host "    exec mode$modeNum" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "  To reset: exec reset"
Write-Host "  ============================================" -ForegroundColor Cyan
Write-Host ""
pause
