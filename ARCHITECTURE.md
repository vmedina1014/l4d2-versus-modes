# L4D2 Private Server — End-to-End Architecture

> Complete system reference: server startup, RCON pipeline, mode execution, and persistence.

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Directory Layout](#2-directory-layout)
3. [Server Startup Sequence](#3-server-startup-sequence)
4. [Config Chain](#4-config-chain)
5. [RCON Layer](#5-rcon-layer)
6. [Mode Execution Pipeline](#6-mode-execution-pipeline)
7. [Mode Persistence Mechanism](#7-mode-persistence-mechanism)
8. [Execution Modes Reference](#8-execution-modes-reference)
9. [Network Topology](#9-network-topology)
10. [End-to-End Request Flow](#10-end-to-end-request-flow)
11. [SourceMod Layer](#11-sourcemod-layer)

---

## 1. System Overview

A single Windows machine runs both the dedicated game server and the operator tooling. Players connect over LAN (or internet via port-forward). The operator switches game modes at runtime via a PowerShell launcher that writes a config file and sends an RCON command simultaneously.

```mermaid
graph TD
    subgraph Host["Host PC — 192.168.1.232"]
        SRCDS["srcds.exe\nDedicated Server :27015"]
        LAUNCHER["pick_mode.bat\n(PowerShell launcher)"]
        RCON_EXE["rcon.exe\n(gorcon-cli)"]
        CFG["left4dead2/cfg/\ncurrent_mode.cfg"]
    end

    subgraph Players
        P1["Player 1 (Host)"]
        P2["Player 2"]
        P3["Player 3-8"]
    end

    LAUNCHER -->|"1. writes exec <mode>"| CFG
    LAUNCHER -->|"2. spawns"| RCON_EXE
    RCON_EXE -->|"RCON TCP :27015\nexec <mode>"| SRCDS
    SRCDS -->|"re-execs on every map load"| CFG
    CFG -->|"exec mode_*.cfg"| SRCDS

    P1 -->|"UDP :27015"| SRCDS
    P2 -->|"UDP :27015"| SRCDS
    P3 -->|"UDP :27015"| SRCDS
```

---

## 2. Directory Layout

```
C:\L4D2\
├── srcds.exe                        # Source dedicated server binary
├── left4dead2.exe                   # Game client binary
├── start_server.bat                 # Server launcher (infinite restart loop)
├── steam_appid.txt                  # App ID 550 (L4D2)
│
├── left4dead2\                      # Game content directory
│   ├── cfg\                         # ← All runtime config lives here
│   │   ├── server.cfg               # Core server settings; execs current_mode
│   │   ├── startup.cfg              # Runs on srcds start: execs server.cfg, loads map
│   │   ├── current_mode.cfg         # Pointer to active mode (rewritten by launcher)
│   │   ├── reset.cfg                # Vanilla convar restore (not in mode rotation)
│   │   ├── mode_fogofwar.cfg        # Custom mode
│   │   ├── mode_glasscannon.cfg     # Custom mode
│   │   ├── mode_horderush.cfg       # Custom mode
│   │   ├── mode_relentless.cfg      # Custom mode
│   │   └── sourcemod\               # SourceMod plugin configs
│   │
│   ├── addons\
│   │   ├── metamod.vdf              # MetaMod:Source loader
│   │   └── sourcemod\               # SourceMod installation
│   │       ├── plugins\             # Installed .smx plugins
│   │       └── extensions\          # Native extensions (.ext.dll)
│   │
│   ├── mapcycle.txt                 # Map rotation
│   ├── missioncycle.txt             # Campaign rotation
│   ├── motd.txt                     # Plain-text message of the day
│   └── logs\                        # Server logs
│
├── versus_modes\                    # Operator tooling (lives outside server tree)
│   ├── pick_mode.bat                # Entry point (bat wrapper → PowerShell)
│   ├── pick_mode.ps1                # Mode picker logic
│   └── rcon.exe                     # gorcon-cli binary
│
└── steamapps\                       # Steam content cache
```

---

## 3. Server Startup Sequence

`start_server.bat` runs `srcds.exe` in an infinite loop so the server auto-restarts on crash.

```mermaid
sequenceDiagram
    actor Operator
    participant BAT as start_server.bat
    participant SRCDS as srcds.exe
    participant STARTUP as startup.cfg
    participant SERVERCFG as server.cfg
    participant CURMODE as current_mode.cfg
    participant MODE as mode_*.cfg

    Operator->>BAT: double-click / run
    loop restart on crash
        BAT->>SRCDS: srcds.exe -console -game left4dead2\n+ip 192.168.1.232 +hostport 27015\n+maxplayers 8 +sv_gametypes versus\n+exec startup
        SRCDS->>STARTUP: exec startup.cfg
        STARTUP->>SERVERCFG: exec server.cfg
        SERVERCFG->>SERVERCFG: apply hostname, rcon_password,\nsv_gametypes, sv_lan, etc.
        SERVERCFG->>CURMODE: exec current_mode
        CURMODE->>MODE: exec mode_<last_pick>
        MODE->>SRCDS: set convars (sv_cheats 1, z_health, etc.)
        STARTUP->>SRCDS: map c8m1_apartment versus
        Note over SRCDS: Server is live and accepting connections
    end
```

**Start command breakdown:**

| Flag | Value | Purpose |
|------|-------|---------|
| `-console` | — | Attach interactive console window |
| `-game` | `left4dead2` | Select game directory |
| `+ip` | `192.168.1.232` | Bind to LAN interface |
| `+hostport` | `27015` | UDP game port (also RCON TCP) |
| `+maxplayers` | `8` | 4 survivors + 4 infected |
| `+sv_gametypes` | `versus` | Start in Versus mode |
| `+exec` | `startup` | Run `cfg/startup.cfg` on load |

---

## 4. Config Chain

Every map load re-executes the full chain from `server.cfg` downward. This is what makes mode persistence work — cheat-protected convars reset on each map load, but the chain immediately re-applies them.

```mermaid
flowchart TD
    START["srcds.exe starts\n+exec startup"] --> STARTUP

    STARTUP["startup.cfg\n─────────────\nexec server.cfg\nmap c8m1_apartment versus"]

    STARTUP --> SERVERCFG

    SERVERCFG["server.cfg  ← re-executed on EVERY map load\n──────────────────────────────────────────\nhostname 'L4D2 Versus Server'\nrcon_password 'alroker'\nsv_gametypes 'versus'\nsv_search_key 'freshprince'\nsv_steamgroup ...\nmaxplayers 8\nsv_lan 0\nlog on\n...\nexec current_mode  ← THE PERSISTENCE HOOK"]

    SERVERCFG --> CURMODE

    CURMODE["current_mode.cfg  ← rewritten by launcher on each pick\n──────────────────────────────────────────\nexec mode_horderush\n  (or: exec mode_fogofwar, exec reset, etc.)"]

    CURMODE --> MODECFG

    MODECFG["mode_<name>.cfg\n──────────────────────────────────────────\nsv_cheats 1\nz_common_limit N\nz_health N\nz_speed N\nz_tank_health N\ndirector_* settings\nammo_* settings\nfog_* settings (Fog of War only)\necho [MODE] <Name> loaded"]

    MODECFG --> LIVE["Convars active in-game"]

    RESET["reset.cfg  ← special, not in mode_* rotation\n──────────────────────────────────────────\nRestores ALL touched convars to\nL4D2 vanilla defaults"]

    CURMODE -->|"if reset was picked"| RESET
    RESET --> LIVE
```

---

## 5. RCON Layer

RCON (Remote CONsole) is a TCP protocol that lets the launcher send console commands to the running server without touching the server window.

```mermaid
sequenceDiagram
    participant PS as pick_mode.ps1
    participant RCONEXE as rcon.exe (gorcon)
    participant SERVER as srcds.exe RCON listener :27015

    PS->>RCONEXE: & rcon.exe -a 192.168.1.232:27015\n           -p alroker\n           "exec mode_horderush"
    RCONEXE->>SERVER: TCP connect :27015
    RCONEXE->>SERVER: RCON auth packet (password: alroker)
    SERVER-->>RCONEXE: Auth OK
    RCONEXE->>SERVER: RCON command: exec mode_horderush
    SERVER-->>RCONEXE: Response (stdout of command)
    RCONEXE-->>PS: exit code 0 (success) or non-zero (fail)
    PS->>PS: Print [OK] or [WARN] based on exit code
```

**RCON configuration:**

| Setting | Value | Where set |
|---------|-------|-----------|
| Password | `alroker` | `server.cfg` → `rcon_password "alroker"` |
| Address | `192.168.1.232:27015` | `pick_mode.ps1` → `$SERVER_IP` / `$SERVER_PORT` |
| Client binary | `rcon.exe` | `versus_modes/rcon.exe` (gorcon-cli) |

The RCON password in `server.cfg` and `$RCON_PASSWORD` in `pick_mode.ps1` must match exactly.

---

## 6. Mode Execution Pipeline

The full lifecycle when an operator picks a mode:

```mermaid
flowchart TD
    A["Operator runs\npick_mode.bat [arg]"] --> B

    B{"Argument type?"}

    B -->|"no arg"| C["Random pick\nGet-Random from 1..N"]
    B -->|"number e.g. 3"| D["Pick mode #3\n(sorted alphabetically)"]
    B -->|"keyword e.g. horde"| E{"Keyword matches?"}
    B -->|"reset / vanilla"| R["modeFile = reset"]

    E -->|"0 matches"| ERR1["Error: no match found\nList available modes"]
    E -->|"1 match"| F["modeFile = matched mode"]
    E -->|">1 match"| G["Show ambiguous list\nPrompt for number"]
    G --> F

    C --> DISC
    D --> DISC
    F --> DISC
    R --> WRITE

    DISC["Auto-discover modes\nGet-ChildItem cfg/mode_*.cfg\nSort by filename\nParse [MODE] <Name> from echo line"]
    DISC --> WRITE

    WRITE["Write current_mode.cfg\nSet-Content ASCII:\n'exec mode_<name>'"]
    WRITE -->|"write OK"| PERSIST["Persisted → mode survives\nall future chapter loads"]
    WRITE -->|"write FAIL"| WARN["WARN: applies current\nchapter only"]

    PERSIST --> RCON
    WARN --> RCON

    RCON["Send RCON command\nrcon.exe -a 192.168.1.232:27015\n         -p alroker\n         'exec mode_<name>'"]

    RCON -->|"exit 0"| OK["[OK] Mode applied\nto current chapter"]
    RCON -->|"non-zero"| WARN2["[WARN] rcon failed\nManual fallback shown"]
```

**Mode discovery logic** — the launcher never has a hardcoded mode list. At runtime:
1. Glob `cfg/mode_*.cfg` — sorted alphabetically → assigns display numbers.
2. Parse each file for `echo [MODE] <Name> loaded` → display name and keyword.
3. Files named `reset.cfg` / `current_mode.cfg` are excluded by the glob pattern itself.

---

## 7. Mode Persistence Mechanism

L4D2 resets cheat-protected convars (`FCVAR_CHEAT`) on every map load. The persistence trick bypasses this without any plugin.

```mermaid
sequenceDiagram
    actor Op as Operator
    participant Launcher as pick_mode.ps1
    participant CFG as current_mode.cfg
    participant Server as srcds.exe

    Op->>Launcher: pick_mode.bat horde

    Launcher->>CFG: overwrite with:\nexec mode_horderush
    Launcher->>Server: RCON: exec mode_horderush
    Server->>Server: load mode_horderush.cfg\napply z_common_limit 50, etc.
    Note over Server: Chapter in progress — mode active

    Note over Server: Map changes (next chapter)
    Server->>Server: re-execute server.cfg\n(L4D2 does this every map load)
    Server->>CFG: exec current_mode
    CFG-->>Server: exec mode_horderush
    Server->>Server: reload mode_horderush.cfg\nreapply all convars
    Note over Server: Mode still active on new chapter

    Op->>Launcher: pick_mode.bat reset
    Launcher->>CFG: overwrite with:\nexec reset
    Launcher->>Server: RCON: exec reset
    Server->>Server: load reset.cfg\nrestore all convars to defaults
    Note over Server: Back to vanilla for remaining chapters
```

**Why `sv_cheats 1` must stay on:**
All custom convar overrides use `FCVAR_CHEAT`-flagged cvars. Turning `sv_cheats 0` inside a mode cfg would immediately invalidate all the values that were just set. All mode cfgs set `sv_cheats 1` and leave it on.

---

## 8. Execution Modes Reference

### Mode: Fog of War (`mode_fogofwar.cfg`)

Heavy visibility penalty. Fewer but tougher commons. Specials gain range and damage.

| Category | Key Changes vs Vanilla |
|----------|----------------------|
| Visibility | `fog_start 64`, `fog_end 600`, `fog_maxdensity 0.9`, color `20 20 25` |
| Commons | limit 18 (↓ from 30), HP 90 (↑), speed 240 |
| Specials | Smoker tongue 850 (↑), Hunter pounce 7dmg (↑), Boomer vomit delay 1.5s (↓) |
| Tank | 6000 HP (vanilla) |
| Survivors | No ammo bonus — fog IS the penalty |
| Best on | Swamp Fever, Hard Rain, Death Toll |

### Mode: Glass Cannon (`mode_glasscannon.cfg`)

Everything hits harder, everything dies faster. Positioning punished severely.

| Category | Key Changes vs Vanilla |
|----------|----------------------|
| Commons | limit 35 (↑), HP 30 (↓), speed 280 (↑) |
| Specials | Tank 4000 HP (↓), Smoker choke 15/tick (↑), Hunter pounce 8/tick (↑) |
| Survivors | Fire damage 60/s (↑ from 40), more pills + adrenaline |
| Director | Fog disabled |
| Best on | The Parish, Dead Center, No Mercy |

### Mode: Horde Rush (`mode_horderush.cfg`)

Overwhelming numbers. Survivors compensated with expanded ammo and throwables.

| Category | Key Changes vs Vanilla |
|----------|----------------------|
| Commons | limit 50 (↑↑), HP 75 (↑), speed 290 (↑), mob size 70 (↑) |
| Specials | Tank 7000 HP (↑), frustration timer 30s (↑) |
| Survivor Ammo | Rifle 500, Shotgun 100, SMG 750, Sniper 200 |
| Director | Pills ×8, pipe bombs ×5, molotovs ×5, bile jars ×4 |
| Best on | Any campaign |

### Mode: Relentless (`mode_relentless.cfg`)

Constant pressure + beefier Tank. Survivors get premium gear and faster rescues.

| Category | Key Changes vs Vanilla |
|----------|----------------------|
| Commons | limit 35, HP 50 (vanilla), speed 250 (vanilla) |
| Specials | Tank 6500 HP (↑), tongue 800 (↑), Hunter pounce 6/tick (↑) |
| Survivor Ammo | Rifle 500, Shotgun 100, SMG 750 |
| Director | Pills ×9, pipe bombs ×6, molotovs ×6, bile ×5 |
| Rescue | min dead time 30s (↓ from 60), distance 3000 (↓ from 4500) |
| Adrenaline | Duration 18s (↑ from 15s) |
| Best on | Dark Carnival, The Parish, Blood Harvest |

### Reset (`reset.cfg`)

Not a mode. Restores every convar touched by any mode back to L4D2 vanilla defaults and clears `current_mode.cfg` so subsequent chapters stay vanilla.

```mermaid
graph LR
    FoW["Fog of War"] --> DELTA_FOW["fog, z_health 90\ntongue_range 850\n..."]
    GC["Glass Cannon"] --> DELTA_GC["z_health 30\nz_speed 280\ninferno_damage 60\n..."]
    HR["Horde Rush"] --> DELTA_HR["z_common_limit 50\nz_tank_health 7000\nammo_*\ndirector_*\n..."]
    RL["Relentless"] --> DELTA_RL["z_tank_health 6500\nrescue_*\nadrenaline_duration\n..."]

    DELTA_FOW --> RESET["reset.cfg\nrestores ALL\nto defaults"]
    DELTA_GC --> RESET
    DELTA_HR --> RESET
    DELTA_RL --> RESET

    RESET --> VANILLA["Vanilla L4D2\nconvar state"]
```

---

## 9. Network Topology

```mermaid
graph TD
    subgraph LAN["Local Network — 192.168.1.x"]
        subgraph HOST["Host PC — 192.168.1.232"]
            SRCDS_NET["srcds.exe\nUDP :27015 (game)\nTCP :27015 (RCON)"]
            LAUNCHER_NET["pick_mode.bat\n(operator tooling)"]
            RCON_NET["rcon.exe"]
            LAUNCHER_NET -->|"TCP localhost:27015"| RCON_NET
            RCON_NET -->|"RCON TCP"| SRCDS_NET
        end

        LAN_P1["LAN Player\n192.168.1.x"]
        LAN_P2["LAN Player\n192.168.1.x"]
        LAN_P1 -->|"UDP 27015"| SRCDS_NET
        LAN_P2 -->|"UDP 27015"| SRCDS_NET
    end

    ROUTER["Home Router\nPort-Forward UDP 27015"]
    INTERNET["Internet"]
    INT_P["Remote Player"]

    SRCDS_NET <-->|"UDP 27015"| ROUTER
    ROUTER <-->|"UDP 27015"| INTERNET
    INTERNET <-->|"UDP 27015"| INT_P

    STEAM["Steam Network\n(Matchmaking / Auth)"]
    SRCDS_NET <-->|"Steam A2S queries\nGSLT auth\nsv_steamgroup"| STEAM
```

**Connection methods for players:**

| Method | Command | Requires |
|--------|---------|----------|
| Direct connect (LAN) | `connect 192.168.1.232:27015` | `sv_lan 0` or `sv_lan 1` |
| Direct connect (internet) | `connect <public-ip>:27015` | Port-forward UDP 27015, `sv_lan 0` |
| Lobby force (LAN) | `mm_dedicated_force_servers 192.168.1.232:27015` | All players set before lobby start |
| Steam search key | `sv_search_key freshprince` | All players set same key |

---

## 10. End-to-End Request Flow

Full trace from operator decision to convars active on server across chapter transitions.

```mermaid
sequenceDiagram
    actor Op as Operator
    participant BAT as pick_mode.bat
    participant PS as pick_mode.ps1
    participant FS as File System\ncurrent_mode.cfg
    participant RCON as rcon.exe
    participant SRV as srcds.exe
    participant PLAYERS as Connected Players

    Note over Op,PLAYERS: Operator wants to switch to Horde Rush mid-session

    Op->>BAT: pick_mode.bat horde
    BAT->>PS: powershell -File pick_mode.ps1 horde

    PS->>FS: Get-ChildItem cfg/mode_*.cfg
    FS-->>PS: [fogofwar, glasscannon, horderush, relentless]
    PS->>PS: keyword "horde" matches "Horde Rush" (1 match)
    PS->>PS: modeFile = mode_horderush

    PS->>FS: Set-Content current_mode.cfg\n"exec mode_horderush"
    FS-->>PS: write OK

    PS->>RCON: & rcon.exe -a 192.168.1.232:27015\n           -p alroker\n           "exec mode_horderush"
    RCON->>SRV: TCP connect + RCON auth
    SRV-->>RCON: auth OK
    RCON->>SRV: exec mode_horderush
    SRV->>SRV: load cfg/mode_horderush.cfg\nz_common_limit 50\nz_health 75\nz_tank_health 7000\n...etc.
    SRV-->>RCON: OK
    RCON-->>PS: exit 0

    PS->>Op: [OK] Mode applied to current chapter\nPersisted — next chapters will keep this mode.

    Note over SRV,PLAYERS: Players in current chapter see effect immediately

    Note over SRV: Chapter ends — L4D2 loads next map

    SRV->>SRV: re-execute server.cfg (automatic)
    SRV->>FS: exec current_mode
    FS-->>SRV: exec mode_horderush
    SRV->>SRV: reload mode_horderush.cfg\nreapply all convars
    Note over SRV,PLAYERS: Mode persists transparently into new chapter
```

---

## 11. SourceMod Layer

MetaMod:Source + SourceMod are installed but only stock plugins are active. No custom L4D2 plugins are currently installed.

```mermaid
graph TD
    SRCDS_SM["srcds.exe"] --> MM["MetaMod:Source\naddons/metamod.vdf\naddons/metamod_x64.vdf"]
    MM --> SM["SourceMod\naddons/sourcemod/"]

    SM --> PLUGINS["Active Plugins (.smx)\n─────────────────────\nadmin-flatfile\nadminhelp / adminmenu\nbasecommands / basebans\nbasechat / basecomm\nbasetriggers / basevotes\nclientprefs\nfuncommands / funvotes\nnextmap\nplayercommands\nreservedslots\nsounds\nantiflood"]

    SM --> EXT["Extensions (.ext.dll)\n─────────────────────\nbintools\nclientprefs\ndbi.sqlite\ndhooks\ngeoip\nregex\nsdkhooks\ntopmenus\n..."]

    SM --> SMCFG["SourceMod Configs\ncfg/sourcemod/\n─────────────────\nsourcemod.cfg\nbasevotes.cfg\nfuncommands.cfg\nsm_warmode_off/on.cfg"]

    PENDING["Pending (not yet installed)\n─────────────────────────\nTeam Manager (team switching)\nScore/Team Manager\nCampaign/Map Voter\nVote Manager 3"]

    style PENDING fill:#4a3300,stroke:#aa7700
```

**SourceMod admin access:** Managed via `addons/sourcemod/configs/admins_simple.ini` (flat-file auth). In-game admin commands available via chat prefix `sm_` or console `sm_*`.

---

## Quick Reference

```
Start server:     double-click start_server.bat  (auto-restarts on crash)

Pick a mode:
  pick_mode.bat              → random mode
  pick_mode.bat 3            → mode #3 (sorted: fogofwar=1, glasscannon=2, horderush=3, relentless=4)
  pick_mode.bat horde        → keyword match
  pick_mode.bat reset        → vanilla restore + clear persistence

RCON direct:
  rcon.exe -a 192.168.1.232:27015 -p alroker "exec mode_horderush"
  rcon.exe -a 192.168.1.232:27015 -p alroker "z_common_limit"    (query a cvar)
  rcon.exe -a 192.168.1.232:27015 -p alroker "status"

Add a mode:       drop cfg/mode_<name>.cfg into left4dead2\cfg\
                  include line: echo [MODE] <Display Name> loaded - <desc>
                  launcher auto-discovers it on next run

Config chain:     srcds +exec startup → startup.cfg → server.cfg
                  → exec current_mode → mode_*.cfg  (re-runs every map load)

Ports:            UDP 27015  game traffic
                  TCP 27015  RCON
```
