# 🧟 L4D2 Versus Modifier Modes

Custom **Versus** modes for a private Left 4 Dead 2 server you and your friends play on.
Each mode is a small config file that tweaks the game (tougher hordes, deadly fog,
glass-cannon damage, etc.). A simple launcher (`pick_mode.bat`) lets you switch modes
— or roll a random one — between rounds, and the choice **sticks for the whole campaign**.

> **New here? Read this top to bottom once.** After the one-time setup, day-to-day use is
> two things: start the server, and run `pick_mode.bat`. That's it.

---

## 🎮 The modes

| # | Name | What it does | Best on |
|---|------|--------------|---------|
| 1 | 🌫️ **Fog of War** | Heavy fog kills visibility; fewer but tankier commons; Smoker/Hunter ambush from the dark | Swamp Fever, Hard Rain, Death Toll |
| 2 | 💀 **Glass Cannon** | Everyone hits harder *and* dies faster — fragile fast commons, hard-hitting specials, more meds | The Parish, Dead Center, No Mercy |
| 3 | 🧟 **Horde Rush** | More commons (faster, tougher) + a Tank buff; survivors get extra ammo and items to keep up | Any |
| 4 | ⚡ **Relentless** | Constant pressure and a beefier Tank; survivors get premium gear and faster rescues | Dark Carnival, The Parish, Blood Harvest |

A **"mode"** is just a `.cfg` file in the `cfg/` folder (e.g. `cfg/mode_horderush.cfg`)
full of console commands the server runs. Nothing more magical than that.

---

## 🧩 How it all fits together

```
  pick_mode.bat   ──(1) writes──►  current_mode.cfg   ──(re-run each map)──►  the chosen mode
   (you run this)  ──(2) RCON───►  the running server  ──────────────────►   applied right now
```

- You run **`pick_mode.bat`** on your PC.
- It tells the **dedicated server** (running on the same PC) to load a mode *right now* (via RCON),
  and saves your choice so the server re-applies it on **every chapter** of the campaign.
- Your friends just **connect to your server** and play.

**Words you'll see:**
- **Dedicated server** — a separate L4D2 program that hosts the game. Everyone (including you) connects to it as a player.
- **RCON** — "remote console": lets `pick_mode.bat` send commands to the server.
- **cfg** — a config file of console commands. `exec name` runs `cfg/name.cfg`.

---

## ✅ What you need (once)

1. **Left 4 Dead 2** (the game) — installed via Steam.
2. **L4D2 Dedicated Server** — a free tool in Steam:
   *Steam → Library → (filter to) **Tools** → "Left 4 Dead 2 Dedicated Server" → Install.*
   It installs to a folder containing `left4dead2\cfg\`.
3. **`rcon.exe`** — download [gorcon (rcon-cli)](https://github.com/gorcon/rcon-cli) and put `rcon.exe`
   in the **same folder as `pick_mode.bat`**.
4. **This repo** — `pick_mode.bat`, and the `cfg/` files.

---

## 🛠️ One-time setup

### Step 1 — Copy the mode files onto the server
Copy everything inside this repo's `cfg/` folder:
```
mode_fogofwar.cfg   mode_glasscannon.cfg   mode_horderush.cfg
mode_relentless.cfg   reset.cfg   current_mode.cfg
```
…into your dedicated server's cfg folder, e.g.:
```
...\steamapps\common\Left 4 Dead 2 Dedicated Server\left4dead2\cfg\
```

### Step 2 — Create `server.cfg`
In that same `left4dead2\cfg\` folder, create (or edit) **`server.cfg`** and paste this:

```
// ---- Basic server identity ----
hostname "Squad Versus"
rcon_password "alroker"          // MUST match pick_mode.bat (see Step 3)
sv_lan 0                         // 1 = LAN only, 0 = friends over the internet

// ---- Versus 4v4 ----
mp_gamemode versus
sv_maxplayers 8                  // 4 survivors + 4 infected

// ---- Let friends in ----
sv_allow_lobby_connect_only 0    // allow direct "connect <ip>" joins
sv_steamgroup_exclusive 0
sv_search_key squadversus        // OPTIONAL: for the lobby join method (see below)

// ---- Allow custom configs / mods ----
sv_consistency 0
sv_pure 0

// ---- Re-apply the picked mode on every chapter ----
exec current_mode                // <-- this is what makes modes persist
```

> ⚠️ **`rcon_password` here must exactly match** the password in `pick_mode.bat`
> (default: `alroker`). If they differ, the launcher can't talk to the server.

### Step 3 — Point the launcher at your server
Open **`pick_mode.bat`** in a text editor and edit the config block at the top:

```powershell
$SERVER_IP      = "127.0.0.1"                       # the server is on this PC
$SERVER_PORT    = 27015                             # default L4D2 port
$RCON_PASSWORD  = "alroker"                          # matches server.cfg
$SERVER_CFG_DIR = "C:\path\to\left4dead2\cfg"        # the folder from Step 1
```

`$SERVER_CFG_DIR` is the most important one — it's the folder the launcher reads modes from
and writes your current choice into. (Leave it blank only if `pick_mode.bat` lives right next
to the server's live `cfg\` folder.)

### Step 4 — Start the server
From the Dedicated Server folder, launch it (a desktop shortcut to this works great):
```
srcds.exe -game left4dead2 -insecure +exec server.cfg +mp_gamemode versus +map c1m1_hotel
```
- `-insecure` — turns off VAC so custom configs/mods don't get players kicked (fine for a private game).
- `+mp_gamemode versus` **before** `+map` — L4D2 needs the mode set first or it loads Campaign.

You now have a running Versus server. Leave this window open.

---

## ▶️ Applying a mode (everyday use)

Run `pick_mode.bat` from its folder (double-click, or run it in a terminal):

```
pick_mode.bat              # roll a RANDOM mode
pick_mode.bat 3            # pick mode #3 by number
pick_mode.bat horde        # pick by keyword (matches the mode name)
pick_mode.bat fog          # if a keyword matches several, it lists them and asks
pick_mode.bat reset        # back to vanilla (and stop re-applying the old mode)
```

What happens when you pick:
1. ✅ The mode is applied to the **current chapter** immediately.
2. 💾 Your choice is saved so it **carries to every following chapter** of the campaign.

Switch modes any time — pick again and the new one takes over. Use `pick_mode.bat reset`
to go fully vanilla.

> **Tip — numbers vs keywords:** mode numbers are assigned alphabetically, so they can shift
> if you add a new mode later. Keywords (`horde`, `fog`, …) always pick the same mode.

---

## 👥 How your friends join

First, where is everyone?

### Playing over the internet
You (the host) need your friends' traffic to reach your PC:
1. **Port-forward** `UDP 27015` on your router to your PC's local IP. (Also forward `27015` for RCON if you ever connect remotely; for normal play UDP 27015 is what matters.)
2. Find your **public IP** (search "what is my IP").
3. Make sure `sv_lan 0` is set (Step 2).

Then pick **one** of these join methods:

**Method A — Direct connect (simplest, most reliable):**
Each friend opens the in-game console (`~`) and types:
```
connect YOUR_PUBLIC_IP:27015
```
> Enable the console once via *Options → Keyboard/Mouse → Allow Developer Console → Enabled*,
> or add `-console` to L4D2's Steam launch options.

**Method B — Private Versus lobby (closest to the "real" Versus experience):**
This routes a normal in-game lobby to *your* server so you get the familiar team-select / ready-up flow.
1. Everyone (host + friends) sets the same search key in console: `sv_search_key squadversus`
   (must match `server.cfg`).
2. The host opens **Play → Versus**, picks the campaign, and **invites friends via Steam**.
3. When the host starts, matchmaking finds your server (by the key) and everyone lands on it.

> ⚠️ Method B depends on game/version quirks and can be finicky. If it doesn't grab your server,
> fall back to **Method A** — direct connect always works once the port is open.

### Playing on the same network (LAN)
Set `sv_lan 1` in `server.cfg`. Friends use **Method A** with your **local** IP
(e.g. `connect 192.168.1.50:27015`). No port-forwarding needed.

---

## 🪶 Don't want to run a dedicated server?

If your group prefers the absolute simplest, most lobby-like setup and you don't mind the host
also being a player, you can host an ordinary **in-game Versus lobby** (Play → Versus → invite via Steam).
This *is* the real lobby experience and joining is trivial.

Trade-off: a normal in-game host can't use the RCON launcher. To switch modes, the **host** opens
the console (`~`) and types it directly:
```
exec mode_horderush      // or any mode_*.cfg
exec reset               // back to vanilla
```
Persistence still works if you put `exec current_mode` in `server.cfg`.

---

## ➕ Adding or removing modes

The launcher **finds modes automatically** — you never edit `pick_mode.bat` to add one.

- **Add a mode:** drop a new `cfg/mode_<name>.cfg` into the server's cfg folder. Any file named
  `mode_*.cfg` is picked up. Add a line like
  `echo [MODE] My Cool Mode loaded - short description` and the launcher uses that as the
  display name and keyword. (No echo line? It falls back to the filename.)
- **Remove a mode:** delete it, or move it into `cfg/beta/` (archived modes there are ignored).

`reset.cfg` and `current_mode.cfg` are special and never show up as pickable modes.

---

## 🆘 Troubleshooting

| Problem | Fix |
|---------|-----|
| **`map` loads Campaign, not Versus** | Set the mode first: `mp_gamemode versus` *then* `map c1m1_hotel`. |
| **Launcher says "rcon.exe not found / connection failed"** | Put `rcon.exe` next to `pick_mode.bat`; check `$RCON_PASSWORD` matches `rcon_password` in `server.cfg`; make sure the server is running. |
| **"cfg folder not found"** | Fix `$SERVER_CFG_DIR` at the top of `pick_mode.bat`. |
| **Mode doesn't carry to the next chapter** | Confirm `exec current_mode` is in `server.cfg`, and `$SERVER_CFG_DIR` points at the *server's* live cfg folder. |
| **Friends can't connect** | Port-forward UDP 27015, set `sv_lan 0`, share your *public* IP, and check Windows Firewall allows `srcds.exe`. |
| **Reset didn't stick** | Use `pick_mode.bat reset` (not just `exec reset`) so it also clears the saved choice. |

---

## 📁 What's in this repo

```
pick_mode.bat            # the launcher (run this)
cfg/
  mode_fogofwar.cfg      # the four playable modes
  mode_glasscannon.cfg
  mode_horderush.cfg
  mode_relentless.cfg
  reset.cfg              # restores all settings to vanilla
  current_mode.cfg       # pointer to your last pick (auto-updated)
  beta/                  # archived experimental modes (ignored by the launcher)
l4d2_developer_cheat_sheet.md   # big reference of L4D2 console commands
```

> ℹ️ The original single-tweak modes (`mode1`–`mode10`) now live in `cfg/beta/` for reference.
> They're not part of the rotation.
