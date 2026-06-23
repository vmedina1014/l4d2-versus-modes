# 🎮 Left 4 Dead 2 — Complete Developer Console Commands Reference

**Total Commands:** ~4,000+ cvars and commands. Organized by category with usage examples.

> ⚠️ Many commands require `sv_cheats 1` (marked 🔒). Some are server-only 🖥️.

---

## 📋 Table of Contents

1. [Enabling the Developer Console](#1-enabling-the-developer-console)
2. [Essential Commands & Cheats](#2-essential-commands--cheats)
3. [Give Command — Weapons & Items](#3-give-command--weapons--items)
4. [Map Commands — All Campaign Codes](#4-map-commands--all-campaign-codes)
5. [Zombie Spawning Commands](#5-zombie-spawning-commands)
6. [AI Director Commands](#6-ai-director-commands)
7. [Bot & Survivor Commands](#7-bot--survivor-commands)
8. [Server & Network Commands](#8-server--network-commands)
9. [Camera & View Commands](#9-camera--view-commands)
10. [Graphics & Rendering Commands](#10-graphics--rendering-commands)
11. [Audio Commands](#11-audio-commands)
12. [Movement & Input Commands](#12-movement--input-commands)
13. [Debug & Developer Commands](#13-debug--developer-commands)
14. [Complete A-Z Command List](#14-complete-a-z-command-list)
15. [Client-Side vs Server-Side Access Levels](#15-client-side-vs-server-side-access-levels)
16. [Troubleshooting](#16-troubleshooting-common-issues)
17. [Setting Up a Modded 4v4 Versus Server](#17-setting-up-a-modded-4v4-versus-server)
18. [Pre-Made Custom Versus Modes](#18-pre-made-custom-versus-modes)
19. [Sources & References](#19-sources--references)

---

## 1. Enabling the Developer Console

### Method 1: Launch Options
1. Right-click *Left 4 Dead 2* in Steam → *Properties...*
2. Under *General > Launch Options*, enter `-console`
3. Press `~` (tilde) to toggle console

### Method 2: In-Game
1. *Options > Keyboard/Mouse* → *Allow Developer Console* → **Enabled**
2. Press `~` to open/close

---

## 2. Essential Commands & Cheats

| Command | Description | Example |
|---------|-------------|---------|
| `sv_cheats` | Enable cheat commands | `sv_cheats 1` |
| `god` 🔒 | Team invincibility | `god 1` |
| `buddha` 🔒 | Take damage but can't die | `buddha 1` |
| `noclip` 🔒 | Fly through walls | `noclip` |
| `notarget` 🔒 | Invisible to AI | `notarget` |
| `give` | Give weapons/items/health | `give rifle_ak47` |
| `sv_infinite_ammo` 🔒 | Unlimited ammo | `sv_infinite_ammo 1` |
| `sv_infinite_primary_ammo` 🔒 | Infinite primary ammo | `sv_infinite_primary_ammo 1` |
| `host_timescale` 🔒 | Game speed (1=normal) | `host_timescale 0.3` |
| `kill` | Kill yourself | `kill` |
| `explode` | Die via explosion | `explode` |
| `burn` | Set on fire (no self-dmg) | `burn` |
| `fire` | Spawn fire (does damage) | `fire` |
| `boom` | Drop pipe bomb at feet | `boom` |
| `thirdperson` | Third-person camera | `thirdperson` |
| `firstperson` | First-person camera | `firstperson` |
| `thirdpersonshoulder` | Over-shoulder view | `thirdpersonshoulder` |
| `mat_fullbright` 🔒 | Max light (0/1/2) | `mat_fullbright 1` |
| `crosshair` | Show/hide crosshair | `crosshair 0` |
| `hidehud` 🔒 | Hide HUD (4=all) | `hidehud 4` |
| `cl_viewmodelfovsurvivor` | Weapon FOV (def: 51) | `cl_viewmodelfovsurvivor 70` |
| `upgrade_add` | Add weapon upgrade | `upgrade_add laser_sight` |
| `impulse` | Actions (101=give all) | `impulse 101` |
| `quit` | Exit game | `quit` |
| `connect` | Join server by IP | `connect 192.168.1.100:27015` |

---

## 3. Give Command — Weapons & Items

### Firearms
| Item | Command |
|------|---------|
| Dual Pistols | `give pistol` |
| Magnum | `give pistol_magnum` |
| Pump Shotgun | `give pumpshotgun` |
| Chrome Shotgun | `give shotgun_chrome` |
| Auto Shotgun | `give autoshotgun` |
| SPAS | `give shotgun_spas` |
| SMG | `give smg` |
| Silenced SMG | `give smg_silenced` |
| MP5 | `give smg_mp5` |
| M16 | `give rifle` |
| AK-47 | `give rifle_ak47` |
| SCAR | `give rifle_desert` |
| SG552 | `give rifle_sg552` |
| M60 | `give rifle_m60` |
| Hunting Rifle | `give hunting_rifle` |
| Military Sniper | `give sniper_military` |
| AWP | `give sniper_awp` |
| Scout | `give sniper_scout` |
| Grenade Launcher | `give weapon_grenade_launcher` |

### Melee
| Item | Command |
|------|---------|
| Chainsaw | `give chainsaw` |
| Katana | `give katana` |
| Machete | `give machete` |
| Frying Pan | `give frying_pan` |
| Guitar | `give electric_guitar` |
| Tonfa | `give tonfa` |
| Crowbar | `give crowbar` |
| Fire Axe | `give fireaxe` |
| Baseball Bat | `give baseball_bat` |
| Cricket Bat | `give cricket_bat` |

### Throwables
| Item | Command |
|------|---------|
| Molotov | `give molotov` |
| Pipe Bomb | `give pipe_bomb` |
| Bile Jar | `give vomitjar` |

### Health & Support
| Item | Command |
|------|---------|
| First Aid Kit | `give first_aid_kit` |
| Pain Pills | `give pain_pills` |
| Adrenaline | `give adrenaline` |
| Defibrillator | `give defibrillator` |
| Refill Health | `give health` |
| Refill Ammo | `give ammo` |
| Incendiary Pack | `give upgradepack_incendiary` |
| Explosive Pack | `give upgradepack_explosive` |

### Misc
| Item | Command |
|------|---------|
| Propane Tank | `give propanetank` |
| Gas Can | `give gascan` |
| Oxygen Tank | `give oxygentank` |
| Gnome | `give gnome` |

---

## 4. Map Commands — All Campaign Codes

> ⚠️ **Always set mode FIRST:** `mp_gamemode versus; map c1m1_hotel`

| Campaign | Ch | Map Code |
|----------|----|----------|
| **Dead Center** | 1 | `c1m1_hotel` |
| | 2 | `c1m2_streets` |
| | 3 | `c1m3_mall` |
| | 4 | `c1m4_atrium` |
| **Dark Carnival** | 1 | `c2m1_highway` |
| | 2 | `c2m2_fairgrounds` |
| | 3 | `c2m3_coaster` |
| | 4 | `c2m4_barns` |
| | 5 | `c2m5_concert` |
| **Swamp Fever** | 1 | `c3m1_plankcountry` |
| | 2 | `c3m2_swamp` |
| | 3 | `c3m3_shantytown` |
| | 4 | `c3m4_plantation` |
| **Hard Rain** | 1 | `c4m1_milltown_a` |
| | 2 | `c4m2_sugarmill_a` |
| | 3 | `c4m3_sugarmill_b` |
| | 4 | `c4m4_milltown_b` |
| | 5 | `c4m5_milltown_escape` |
| **The Parish** | 1 | `c5m1_waterfront` |
| | 2 | `c5m2_park` |
| | 3 | `c5m3_cemetery` |
| | 4 | `c5m4_quarter` |
| | 5 | `c5m5_bridge` |
| **The Passing** | 1 | `c6m1_riverbank` |
| | 2 | `c6m2_bedlam` |
| | 3 | `c6m3_port` |
| **The Sacrifice** | 1 | `c7m1_docks` |
| | 2 | `c7m2_barge` |
| | 3 | `c7m3_port` |
| **No Mercy** | 1 | `c8m1_apartment` |
| | 2 | `c8m2_subway` |
| | 3 | `c8m3_sewers` |
| | 4 | `c8m4_interior` |
| | 5 | `c8m5_rooftop` |
| **Crash Course** | 1 | `c9m1_alleys` |
| | 2 | `c9m2_lots` |
| **Death Toll** | 1 | `c10m1_caves` |
| | 2 | `c10m2_drainage` |
| | 3 | `c10m3_ranchhouse` |
| | 4 | `c10m4_mainstreet` |
| | 5 | `c10m5_houseboat` |
| **Dead Air** | 1 | `c11m1_greenhouse` |
| | 2 | `c11m2_offices` |
| | 3 | `c11m3_garage` |
| | 4 | `c11m4_terminal` |
| | 5 | `c11m5_runway` |
| **Blood Harvest** | 1 | `c12m1_hilltop` |
| | 2 | `c12m2_traintunnel` |
| | 3 | `c12m3_bridge` |
| | 4 | `c12m4_barn` |
| | 5 | `c12m5_cornfield` |
| **Cold Stream** | 1 | `c13m1_alpinecreek` |
| | 2 | `c13m2_southpinestream` |
| | 3 | `c13m3_memorialbridge` |
| | 4 | `c13m4_cutthroatcreek` |

---

## 5. Zombie Spawning Commands

| Command | Description |
|---------|-------------|
| `z_spawn zombie` | Spawn a common infected |
| `z_spawn mob` | Spawn a horde |
| `z_spawn boomer` | Spawn Boomer |
| `z_spawn hunter` | Spawn Hunter |
| `z_spawn smoker` | Spawn Smoker |
| `z_spawn tank` | Spawn Tank |
| `z_spawn witch` | Spawn Witch |
| `z_spawn charger` | Spawn Charger |
| `z_spawn jockey` | Spawn Jockey |
| `z_spawn spitter` | Spawn Spitter |
| `z_spawn auto` | Random special |

### Zombie Config

| Command | Description | Default | Example |
|---------|-------------|---------|---------|
| `z_common_limit` | Max commons | 30 | `z_common_limit 100` |
| `z_health` | Common HP | 50 | `z_health 75` |
| `z_speed` | Common speed | 250 | `z_speed 300` |
| `z_tank_health` | Tank HP | 6000 | `z_tank_health 8000` |
| `z_witch_health` | Witch HP | 1000 | `z_witch_health 500` |
| `z_witch_damage` | Witch dmg/hit | 100 | `z_witch_damage 200` |
| `z_witch_speed` | Witch speed | 300 | `z_witch_speed 400` |
| `z_pounce_damage` | Hunter pounce dmg | 5 | `z_pounce_damage 8` |
| `z_frustration_lifetime` | Tank AI takeover (sec) | 20 | `z_frustration_lifetime 40` |
| `tongue_range` | Smoker tongue range | 750 | `tongue_range 900` |
| `tongue_choke_damage_amount` | Smoker choke dmg | 10 | `tongue_choke_damage_amount 15` |
| `z_mega_mob_size` | Mega mob size | 50 | `z_mega_mob_size 70` |

---

## 6. AI Director Commands

| Command | Description | Example |
|---------|-------------|---------|
| `director_stop` | Stop all spawning | `director_stop` |
| `director_start` | Re-enable spawning | `director_start` |
| `director_force_panic_event` | Force horde | `director_force_panic_event` |
| `director_panic_forever` | Endless panic (0/1) | `director_panic_forever 1` |
| `director_no_mobs` | Disable mobs (0/1) | `director_no_mobs 1` |
| `director_force_tank` | Force Tank spawn | `director_force_tank` |
| `director_force_witch` | Force Witch spawn | `director_force_witch` |
| `director_afk_timeout` | AFK timeout (sec) | `director_afk_timeout 300` |
| `director_allow_infected_bots` | Infected bots (0/1) | `director_allow_infected_bots 1` |
| `director_pain_pill_density` | Pills per 100 sq yds | `director_pain_pill_density 8` |
| `director_pipe_bomb_density` | Pipes per 100 sq yds | `director_pipe_bomb_density 5` |
| `director_molotov_density` | Molotovs per 100 sq yds | `director_molotov_density 5` |

---

## 7. Bot & Survivor Commands

| Command | Description | Example |
|---------|-------------|---------|
| `sb_takecontrol` | Take control of bot | `sb_takecontrol Coach` |
| `sb_stop` | Freeze survivor bots | `sb_stop 1` |
| `sb_open_fire` | Bots fire continuously | `sb_open_fire 1` |
| `sb_friendlyfire` | Bot FF (0/1) | `sb_friendlyfire 1` |
| `sb_all_bot_game` | Allow all-bot game | `sb_all_bot_game 1` |
| `bot_mimic` | Bots mimic you | `bot_mimic 1` |
| `nb_stop` | Freeze ALL bots | `nb_stop 1` |
| `kick` | Kick player | `kick PlayerName` |
| `jointeam` | Join team (2=surv, 3=inf) | `jointeam 2` |
| `warp_all_survivors_here` | TP all survivors to you | `warp_all_survivors_here` |
| `warp_all_survivors_to_finale` | TP to finale | `warp_all_survivors_to_finale` |
| `warp_to_start_area` | TP to map start | `warp_to_start_area` |
| `rescue_distance` | Rescue distance (def: 4500) | `rescue_distance 100` |
| `rescue_min_dead_time` | Min dead time (def: 60s) | `rescue_min_dead_time 30` |

---

## 8. Server & Network Commands

| Command | Description | Example |
|---------|-------------|---------|
| `sv_cheats` | Enable cheats (0/1) | `sv_cheats 1` |
| `sv_lan` | LAN-only | `sv_lan 1` |
| `sv_password` | Server password | `sv_password "pass"` |
| `sv_alltalk` | All-talk (0/1) | `sv_alltalk 1` |
| `mp_gamemode` | Set game mode | `mp_gamemode versus` |
| `mp_restartgame` | Restart in X sec | `mp_restartgame 1` |
| `maxplayers` | Max players | `maxplayers 8` |
| `vs_max_team_switches` | Team switches (def: 1) | `vs_max_team_switches 99` |
| `sv_consistency` | File checks | `sv_consistency 0` |
| `net_graph` | Network stats (0-4) | `net_graph 1` |
| `cl_interp` | Interpolation | `cl_interp 0` |
| `cl_cmdrate` | Command rate | `cl_cmdrate 100` |
| `cl_updaterate` | Update rate | `cl_updaterate 100` |

---

## 9. Camera & View Commands

| Command | Description | Example |
|---------|-------------|---------|
| `thirdperson` | Third-person | `thirdperson` |
| `firstperson` | First-person | `firstperson` |
| `thirdpersonshoulder` | Over-shoulder | `thirdpersonshoulder` |
| `cam_idealdist` | Camera distance | `cam_idealdist 150` |
| `fov_desired` | Field of view | `fov_desired 90` |
| `cl_viewmodelfovsurvivor` | Weapon FOV (def: 51) | `cl_viewmodelfovsurvivor 70` |
| `spec_next` / `spec_prev` | Spectate players | `spec_next` |

---

## 10. Graphics & Rendering

| Command | Description | Example |
|---------|-------------|---------|
| `mat_fullbright` | Full brightness (0/1/2) | `mat_fullbright 1` |
| `fog_override` | Allow fog changes | `fog_override 1` |
| `fog_enable` | Enable/disable fog | `fog_enable 0` |
| `r_drawviewmodel` | Weapon model (0/1) | `r_drawviewmodel 0` |
| `cl_drawHUD` | Show HUD (0/1) | `cl_drawHUD 0` |
| `fps_max` | FPS cap (0=unlimited) | `fps_max 300` |
| `cl_showfps` | FPS counter | `cl_showfps 1` |
| `mat_postprocess_enable` | Post-processing | `mat_postprocess_enable 0` |
| `mat_grain_scale_override` | Film grain (0=off) | `mat_grain_scale_override 0` |

---

## 11. Audio Commands

| Command | Description | Example |
|---------|-------------|---------|
| `volume` | Master (0.0-1.0) | `volume 0.5` |
| `snd_musicvolume` | Music volume | `snd_musicvolume 0.3` |
| `snd_mute_losefocus` | Mute alt-tab | `snd_mute_losefocus 0` |
| `voice_enable` | Voice chat (0/1) | `voice_enable 1` |
| `stopsound` | Stop all sounds | `stopsound` |

---

## 12. Movement & Input

| Command | Description | Example |
|---------|-------------|---------|
| `bind` | Bind key | `bind F1 "give first_aid_kit"` |
| `unbind` | Remove binding | `unbind F1` |
| `sensitivity` | Mouse sens | `sensitivity 2.5` |
| `m_rawinput` | Raw mouse (0/1) | `m_rawinput 1` |
| `+forward/+back` | Move | `+forward` |
| `+jump/+duck` | Jump/Crouch | `+jump` |
| `+attack/+attack2` | Fire/Shove | `+attack` |
| `slot1`-`slot5` | Weapon slots | `slot1` |
| `lastinv` | Last weapon | `lastinv` |

---

## 13. Debug & Developer

| Command | Description | Example |
|---------|-------------|---------|
| `ent_create` | Spawn entity | `ent_create infected` |
| `ent_remove` | Delete at crosshair | `ent_remove` |
| `ent_remove_all` | Remove all of type | `ent_remove_all infected` |
| `ent_fire` | Fire input | `ent_fire !self ignite` |
| `getpos` / `setpos` | Get/set position | `setpos 100 200 300` |
| `record` / `stop` | Demo recording | `record mydemo` |
| `status` | Server info | `status` |
| `find` | Search commands | `find zombie` |
| `cvarlist` | List all cvars | `cvarlist` |
| `exec` | Execute .cfg | `exec autoexec.cfg` |
| `alias` | Command macro | `alias gm "sv_cheats 1; god 1"` |

---

## 14. Complete A-Z Command List

> 💡 L4D2 has ~4,000+ commands. Explore in-game:
> - `find [keyword]` — Search (e.g., `find zombie`)
> - `cvarlist` — Dump full list
> - `help [command]` — Details on any command
> - `differences` — Show all non-default cvars
> - `con_logfile "out.txt"` then `cvarlist` — Export to file

### Key Prefixes

| Prefix | Category | ~Count |
|--------|----------|--------|
| `ai_` | AI behavior | ~20 |
| `ammo_` | Ammunition | ~20 |
| `boomer_`/`charger_`/`hunter_`/`jockey_`/`smoker_`/`spitter_` | Special infected | ~50+ |
| `cl_` | Client-side | ~100+ |
| `director_` | AI Director | ~20 |
| `ent_` | Entity manipulation | ~15 |
| `mat_` | Materials/rendering | ~80+ |
| `mp_` | Multiplayer rules | ~15 |
| `nb_`/`bot_`/`sb_` | Bot control | ~30 |
| `net_` | Networking | ~30 |
| `r_` | Rendering | ~80+ |
| `sv_` | Server settings | ~100+ |
| `z_` | Zombie/infected | ~200+ |

---

## 15. Client-Side vs Server-Side Access Levels

> ⚠️ Solo (local via `map`) = you're client AND host. On someone else's server = client-side only.

| Category | Who Can Use | Where |
|----------|-------------|-------|
| **Client** (`cl_*`, binds, volume) | Anyone | Local machine |
| **Server** (`sv_*`, `mp_*`) | Host/admin only | Server |
| **Cheats** (`god`, `noclip`, `give`) | Anyone after `sv_cheats 1` | Server |
| **Replicated** | Server controls | Pushed to clients |

> 💡 Check flags: type command name alone (e.g., `sv_cheats`) to see `FCVAR_CHEAT`, `FCVAR_REPLICATED`, etc.

---

## 16. Troubleshooting: Common Issues

### `map ... versus` Loads Campaign Instead

**Problem:** `map c1m1_hotel versus` defaults to Campaign.

**Fix — Set mode FIRST:**
```
mp_gamemode versus
map c1m1_hotel
```
Or: `mp_gamemode versus; map c1m1_hotel`

**Why:** L4D2 reads `mp_gamemode` at map init. The shorthand argument often doesn't process in time.

---

## 17. Setting Up a Modded 4v4 Versus Server

### `server.cfg`
Path: `left4dead2/cfg/server.cfg`
```
// === 4v4 VERSUS SERVER ===
hostname "Your Squad's Versus Server"
sv_password "yourpassword"        // Remove for open server
mp_gamemode versus
sv_maxplayers 8                   // 4v4
sv_allow_lobby_connect_only 0
sv_steamgroup_exclusive 0
vs_max_team_switches 1
sv_alltalk 0
sv_voiceenable 1
director_afk_timeout 120
sv_consistency 0                  // Allow mods
sv_pure 0                         // Required for Workshop content
exec modded_versus                // Auto-load custom settings
```

### Persistence
`server.cfg` re-executes every map change → your mods persist automatically through the campaign.

### Quick Reference

| Action | Command |
|--------|---------|
| Start match | `mp_gamemode versus; exec mode_horderush; map c1m1_hotel` |
| Friends join | `connect YOUR_IP:27015` |
| Next map | `changelevel c1m2_streets` |
| Restart map | `mp_restartgame 1` |
| Kick | `kick PlayerName` |
| Tweak mid-game | `sv_cheats 1; z_tank_health 12000; sv_cheats 0` |
| Switch mode | `exec mode_fogofwar; changelevel c3m1_plankcountry` |
| Reset to vanilla | `exec mode_vanilla` |

---

## 18. 🎭 Pre-Made Custom Versus Modes

Balanced configs for fair 4v4 Versus. Save as `.cfg` in `left4dead2/cfg/`.

### Mode Comparison

| Mode | Commons | Specials | Survivors | Best Maps |
|------|---------|----------|-----------|-----------|
| 🧟 **Horde Rush** | +67% more, faster, tougher | Slight Tank buff | +25% ammo, more items | Any |
| 🌫️ **Fog of War** | -40% fewer, +80% HP | Smoker/Hunter buffed | Standard (fog = penalty) | Swamp Fever, Hard Rain |
| 💀 **Glass Cannon** | Fragile but fast | Hit hard, die fast | More meds | The Parish, Dead Center |
| ⚡ **Relentless** | Normal, constant waves | Slight buffs | Premium supplies, fast rescue | Dark Carnival, Blood Harvest |

---

### 🧟 Mode 1: "Horde Rush"

*Overwhelm with numbers; survivors get extra supplies to compensate.*

**File:** `cfg/mode_horderush.cfg`

```
// =============================================
// HORDE RUSH MODE
// =============================================
sv_cheats 1

// --- COMMON INFECTED ---
z_common_limit 50              // Max alive at once (default: 30)
z_health 75                    // HP per common (default: 50)
z_speed 290                    // Max movement speed (default: 250)
z_mega_mob_size 70             // Zombies in mega mob event (default: 50)

// --- SPECIAL INFECTED ---
z_tank_health 7000             // Tank hit points (default: 6000)
z_frustration_lifetime 30      // Sec before Tank AI takeover (default: 20)
tongue_range 750               // Smoker tongue reach (default: 750)
z_pounce_damage 5              // Hunter pounce dmg/tick (default: 5)
tongue_choke_damage_amount 10  // Smoker choke dmg/tick (default: 10)
charger_pz_claw_dmg 10         // Charger melee swipe dmg (default: 10)
hunter_pz_claw_dmg 6           // Hunter melee claw dmg (default: 6)

// --- SURVIVOR COMPENSATION ---
ammo_assaultrifle_max 500      // Rifle reserve ammo (default: 360)
ammo_shotgun_max 100           // Shotgun reserve ammo (default: 80)
ammo_smg_max 750               // SMG reserve ammo (default: 650)
ammo_sniperrifle_max 200       // Sniper reserve ammo (default: 180)
director_pain_pill_density 8   // Pills per 100 sq yards (default: 4)
director_pipe_bomb_density 5   // Pipe bombs per 100 sq yards (default: 3)
director_molotov_density 5     // Molotovs per 100 sq yards (default: 3)
director_vomitjar_density 4    // Bile jars per 100 sq yards (default: 2)

// --- DIRECTOR ---
director_panic_forever 0       // Endless panic events (default: 0)
director_no_mobs 0             // Disable mob rushes (default: 0)
fog_override 0                 // Allow fog manipulation (default: 0)

sv_cheats 0
```

**Usage:** `exec mode_horderush; mp_gamemode versus; map c1m1_hotel`

---

### 🌫️ Mode 2: "Fog of War"

*Low visibility. Fewer but tankier commons. Specials ambush from the dark.*

**File:** `cfg/mode_fogofwar.cfg`

```
// =============================================
// FOG OF WAR MODE
// =============================================
sv_cheats 1

// --- VISIBILITY ---
fog_override 1                 // Allow fog manipulation (default: 0)
fog_enable 1                   // Toggle fog rendering (default: 1)
fog_start 64                   // Distance fog begins, units (default: varies/map)
fog_end 600                    // Distance fog is opaque (default: varies/map)
fog_color "20 20 25"           // RGB fog color (default: varies/map)
fog_maxdensity 0.9             // Max fog thickness 0-1 (default: varies/map)

// --- COMMON INFECTED ---
z_common_limit 18              // Max alive at once (default: 30)
z_health 90                    // HP per common (default: 50)
z_speed 240                    // Max movement speed (default: 250)
z_mega_mob_size 40             // Zombies in mega mob (default: 50)

// --- SPECIAL INFECTED ---
tongue_range 850               // Smoker tongue reach (default: 750)
z_pounce_damage 7              // Hunter pounce dmg/tick (default: 5)
boomer_vomit_delay 1.5         // Sec before Boomer vomits (default: ~2)
charger_pz_claw_dmg 10         // Charger melee swipe dmg (default: 10)
hunter_pz_claw_dmg 6           // Hunter melee claw dmg (default: 6)
tongue_choke_damage_amount 10  // Smoker choke dmg/tick (default: 10)

// --- TANK ---
z_tank_health 6000             // Tank hit points (default: 6000)
z_frustration_lifetime 18      // Sec before Tank AI takeover (default: 20)

// --- WITCH ---
z_witch_speed 280              // Witch chase speed (default: 300)
z_witch_flashlight_range 300   // Flashlight startle range (default: 500)
z_witch_health 1000            // Witch hit points (default: 1000)

// --- SURVIVORS: Standard (fog IS the penalty) ---
ammo_assaultrifle_max 360      // Rifle reserve ammo (default: 360)
ammo_shotgun_max 80            // Shotgun reserve ammo (default: 80)
ammo_smg_max 650               // SMG reserve ammo (default: 650)
director_pain_pill_density 4   // Pills per 100 sq yards (default: 4)
director_panic_forever 0       // Endless panic events (default: 0)
director_no_mobs 0             // Disable mob rushes (default: 0)

sv_cheats 0
```

**Usage:** `exec mode_fogofwar; mp_gamemode versus; map c3m1_plankcountry`
**Best on:** Swamp Fever, Hard Rain, Death Toll

---

### 💀 Mode 3: "Glass Cannon"

*Everyone hits harder, everyone dies faster. Positioning is everything.*

**File:** `cfg/mode_glasscannon.cfg`

```
// =============================================
// GLASS CANNON MODE
// =============================================
sv_cheats 1

// --- COMMON INFECTED ---
z_common_limit 35              // Max alive at once (default: 30)
z_health 30                    // HP per common (default: 50)
z_speed 280                    // Max movement speed (default: 250)
z_mega_mob_size 50             // Zombies in mega mob (default: 50)

// --- SPECIAL INFECTED ---
z_tank_health 4000             // Tank hit points (default: 6000)
tongue_choke_damage_amount 15  // Smoker choke dmg/tick (default: 10)
z_pounce_damage 8              // Hunter pounce dmg/tick (default: 5)
tongue_range 800               // Smoker tongue reach (default: 750)
charger_pz_claw_dmg 12         // Charger melee swipe dmg (default: 10)
hunter_pz_claw_dmg 8           // Hunter melee claw dmg (default: 6)
z_frustration_lifetime 20      // Sec before Tank AI takeover (default: 20)

// --- SURVIVORS ---
inferno_damage 60              // Fire/molotov dmg per second (default: 40)
director_pain_pill_density 7   // Pills per 100 sq yards (default: 4)
director_adrenaline_density 5  // Adrenaline per 100 sq yards (default: 3)
ammo_assaultrifle_max 360      // Rifle reserve ammo (default: 360)
ammo_shotgun_max 80            // Shotgun reserve ammo (default: 80)

// --- MISC ---
fog_override 0                 // Allow fog manipulation (default: 0)
director_panic_forever 0       // Endless panic events (default: 0)
director_no_mobs 0             // Disable mob rushes (default: 0)

sv_cheats 0
```

**Usage:** `exec mode_glasscannon; mp_gamemode versus; map c5m1_waterfront`
**Best on:** The Parish, Dead Center, No Mercy

---

### ⚡ Mode 4: "Relentless"

*Director never stops. Specials keep coming. Survivors get premium gear.*

**File:** `cfg/mode_relentless.cfg`

```
// =============================================
// RELENTLESS MODE
// =============================================
sv_cheats 1

// --- COMMON INFECTED ---
z_common_limit 35              // Max alive at once (default: 30)
z_health 50                    // HP per common (default: 50)
z_speed 250                    // Max movement speed (default: 250)
z_mega_mob_size 55             // Zombies in mega mob (default: 50)

// --- SPECIAL INFECTED ---
z_tank_health 6500             // Tank hit points (default: 6000)
z_frustration_lifetime 25      // Sec before Tank AI takeover (default: 20)
tongue_range 800               // Smoker tongue reach (default: 750)
z_pounce_damage 6              // Hunter pounce dmg/tick (default: 5)
tongue_choke_damage_amount 10  // Smoker choke dmg/tick (default: 10)
charger_pz_claw_dmg 10         // Charger melee swipe dmg (default: 10)
hunter_pz_claw_dmg 6           // Hunter melee claw dmg (default: 6)

// --- DIRECTOR ---
director_panic_forever 0       // Endless panic events (default: 0)
director_no_mobs 0             // Disable mob rushes (default: 0)

// --- SURVIVOR COMPENSATION ---
ammo_assaultrifle_max 500      // Rifle reserve ammo (default: 360)
ammo_shotgun_max 100           // Shotgun reserve ammo (default: 80)
ammo_smg_max 750               // SMG reserve ammo (default: 650)
director_pain_pill_density 9   // Pills per 100 sq yards (default: 4)
director_pipe_bomb_density 6   // Pipe bombs per 100 sq yards (default: 3)
director_molotov_density 6     // Molotovs per 100 sq yards (default: 3)
director_vomitjar_density 5    // Bile jars per 100 sq yards (default: 2)
adrenaline_duration 18         // Adrenaline effect seconds (default: 15)

// --- FASTER RESCUE ---
rescue_min_dead_time 30        // Sec dead before rescue (default: 60)
rescue_distance 3000           // Travel dist for rescue spawn (default: 4500)

// --- FOG ---
fog_override 0                 // Allow fog manipulation (default: 0)

sv_cheats 0
```

**Usage:** `exec mode_relentless; mp_gamemode versus; map c2m1_highway`
**Best on:** Dark Carnival, The Parish, Blood Harvest

---

### 🔄 Vanilla Reset

Restores all defaults after custom modes.

**File:** `cfg/mode_vanilla.cfg`

```
// =============================================
// VANILLA RESET
// =============================================
sv_cheats 1

// Common Infected
z_common_limit 30              // Max alive at once (default: 30)
z_health 50                    // HP per common (default: 50)
z_speed 250                    // Max movement speed (default: 250)
z_mega_mob_size 50             // Zombies in mega mob (default: 50)

// Special Infected
z_tank_health 6000             // Tank hit points (default: 6000)
z_frustration_lifetime 20      // Sec before Tank AI takeover (default: 20)
tongue_range 750               // Smoker tongue reach (default: 750)
tongue_choke_damage_amount 10  // Smoker choke dmg/tick (default: 10)
z_pounce_damage 5              // Hunter pounce dmg/tick (default: 5)
charger_pz_claw_dmg 10         // Charger melee swipe dmg (default: 10)
hunter_pz_claw_dmg 6           // Hunter melee claw dmg (default: 6)
boomer_vomit_delay 2           // Sec before Boomer vomits (default: ~2)

// Witch
z_witch_speed 300              // Witch chase speed (default: 300)
z_witch_health 1000            // Witch hit points (default: 1000)
z_witch_flashlight_range 500   // Flashlight startle range (default: 500)

// Survivors / Ammo
ammo_assaultrifle_max 360      // Rifle reserve ammo (default: 360)
ammo_shotgun_max 80            // Shotgun reserve ammo (default: 80)
ammo_smg_max 650               // SMG reserve ammo (default: 650)
ammo_sniperrifle_max 180       // Sniper reserve ammo (default: 180)
adrenaline_duration 15         // Adrenaline effect seconds (default: 15)
rescue_min_dead_time 60        // Sec dead before rescue (default: 60)
rescue_distance 4500           // Travel dist for rescue spawn (default: 4500)
inferno_damage 40              // Fire/molotov dmg per second (default: 40)

// Director
director_panic_forever 0       // Endless panic events (default: 0)
director_no_mobs 0             // Disable mob rushes (default: 0)
director_pain_pill_density 4   // Pills per 100 sq yards (default: 4)
director_pipe_bomb_density 3   // Pipe bombs per 100 sq yards (default: 3)
director_molotov_density 3     // Molotovs per 100 sq yards (default: 3)
director_vomitjar_density 2    // Bile jars per 100 sq yards (default: 2)
director_adrenaline_density 3  // Adrenaline per 100 sq yards (default: 3)

// Fog
fog_override 0                 // Allow fog manipulation (default: 0)

sv_cheats 0
```

---

## 19. Sources & References

1. **Valve Developer Community Wiki** — Official L4D2 console commands list
   - https://developer.valvesoftware.com/wiki/List_of_Left_4_Dead_2_console_commands_and_variables

2. **Steam Guide: "L4D2 Complete Console Commands"** by V (2025) — 4,000+ commands
   - https://steamcommunity.com/sharedfiles/filedetails/?id=3541480094

3. **Commands.gg — L4D2** — Interactive database with generators
   - https://commands.gg/l4d2

4. **Commands.gg — Give Command & Item IDs**
   - https://commands.gg/l4d2/give

5. **Commands.gg — Map Codes**
   - https://commands.gg/l4d2/map

6. **Steam Guide: "Console & Cheat Codes"** by AymericTheNightmare (2013/2021)
   - https://steamcommunity.com/sharedfiles/filedetails/?id=124977774

7. **Valve Developer Community — L4D2 Docs**
   - https://developer.valvesoftware.com/wiki/Left_4_Dead_2/Docs

---

*Compiled from community and official sources. June 2026. Left 4 Dead 2 © Valve Corporation.*
