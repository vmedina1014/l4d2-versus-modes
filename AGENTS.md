# AGENTS.md — context for AI agents working in this repo

This file orients any agent (or human) picking up this project. Read it before making
changes. End-user docs live in `README.md`; this file is the engineering/handoff context.

_Last updated: 2026-06-23._

---

## What this project is

Custom **Left 4 Dead 2 Versus** modes for a private server the owner plays on with friends.
A "mode" is a `.cfg` file of console commands that retunes the match (horde size, special
infected damage, fog, ammo, etc.). A Windows launcher (`pick_mode.bat`) applies a mode — or a
random one — to a running dedicated server and makes the choice persist across campaign chapters.

**Target platform: Windows.** Do not introduce anything that breaks that assumption
(no bash-isms in the launcher, no POSIX-only tooling). The dev/edit machine is macOS, but the
code runs on Windows.

---

## How it works (architecture)

```
pick_mode.bat ──(1) writes "exec <mode>"──► cfg/current_mode.cfg ──(re-exec'd each map by server.cfg)──► mode persists
              ──(2) RCON "exec <mode>"─────► running dedicated server ─────────────────────────────────► applied now
```

- The launcher is **PowerShell embedded in a `.bat`** (polyglot header at the top — leave it intact).
- It talks to a **local dedicated server** over **RCON** (`127.0.0.1:27015`). RCON is a
  dedicated-server feature; a normal in-game/listen host can't use it (the README documents a
  console-command fallback for that case).
- **Persistence across chapters** is the key trick: L4D2 resets cheat-flagged convars on every
  map load, so a one-shot RCON apply only affects the current chapter. The server's `server.cfg`
  (which re-executes every map load) contains `exec current_mode`, and the launcher rewrites
  `cfg/current_mode.cfg` on each pick. So the chosen mode re-applies every chapter until changed.

---

## Repo layout

```
pick_mode.bat                 # launcher (PowerShell-in-.bat). Run on Windows.
cfg/
  mode_fogofwar.cfg           # the 4 playable modes (anything named mode_*.cfg is auto-discovered)
  mode_glasscannon.cfg
  mode_horderush.cfg
  mode_relentless.cfg
  reset.cfg                   # vanilla restore (NOT mode_* → never appears as a pickable mode)
  current_mode.cfg            # pointer to last pick; rewritten by the launcher; defaults to `exec reset`
  beta/                       # archived original mode1-10 single-convar tweaks; ignored (not recursed)
README.md                     # end-user setup + usage guide (newcomer-friendly)
l4d2_developer_cheat_sheet.md # large reference of L4D2 console commands; §18 = source of the 4 modes
AGENTS.md                     # this file
```

---

## Conventions (follow these)

- **Adding a mode = drop a `cfg/mode_<name>.cfg` file.** The launcher auto-discovers `mode_*.cfg`
  at runtime — **never hardcode a mode list in `pick_mode.bat`.**
- Each mode cfg should include a line:
  `echo [MODE] <Display Name> loaded - <short desc>`
  The launcher parses `<Display Name>` from this for the menu label and keyword matching
  (regex `\[MODE\]\s+(.+?)\s+loaded`). No echo line → it falls back to the filename.
- Mode cfgs wrap settings in `sv_cheats 1` … `sv_cheats 0` (matches the cheat sheet and keeps
  cheats off during play). Values still apply for the current map; persistence handles map changes.
- **Line endings: keep LF.** All current files are LF and work on the owner's Windows setup;
  don't introduce CRLF/BOM. When writing cfgs the launcher uses `Set-Content -Encoding ASCII`
  (no BOM) — keep it that way so L4D2 parses the first line.
- **Keep `reset.cfg` and `current_mode.cfg` non-`mode_*`** so they stay out of the rotation.
- Commit messages: clear and descriptive. Owner commits directly to `main` on this personal repo
  (remote: github.com/vmedina1014/l4d2-versus-modes). Commit/push only when asked.

---

## Decisions already made (don't relitigate without reason)

- **Descriptive mode filenames** (`mode_horderush.cfg`) over numbered (`mode1.cfg`) — matches the
  cheat sheet §18 and is self-documenting. The launcher assigns display numbers by sorted filename
  (so numbers can shift when modes are added; **keywords are the stable selector**).
- **`reset.cfg`** (not `mode_vanilla.cfg`) so the long-standing `exec reset` reference keeps working.
- **Launcher uses an array of mode objects, not `[ordered]@{}`** — PowerShell's ordered-dictionary
  does *positional* indexing on `[int]`, which would make the file lookup pick the wrong mode.
- **Original `mode1`–`mode10`** (single-convar tweaks) were archived to `cfg/beta/`, not deleted.
- **`$SERVER_CFG_DIR`** at the top of the launcher points at the server's live cfg folder; the
  launcher discovers modes there and writes `current_mode.cfg` there. Blank → falls back to the
  `cfg/` next to the script. (Owner's setup: launcher and server are on the same box but the
  server's `cfg` is a separate path, so this var must be set.)

---

## Current state (as of 2026-06-23)

- ✅ 4 modes + reset implemented and committed; original 10 archived to `cfg/beta/`.
- ✅ Launcher auto-discovers modes, persists picks across chapters, supports random / number /
  keyword / `reset`.
- ✅ README rewritten as a step-by-step newcomer guide (server setup, applying modes, friends joining).
- ✅ All committed and pushed to `main`.

## Open items / things to verify

1. **The launcher has not been executed on Windows yet** — it was authored on macOS where `pwsh`
   isn't installed, so it couldn't be run end-to-end. Smoke test on the Windows box:
   - `pick_mode.bat horde` → mode applies to current chapter
   - change chapter → confirm the mode still holds
   - `pick_mode.bat reset` → back to vanilla and stays vanilla next chapter
2. **Networking sections in the README are unverified** (web access was unavailable when written).
   Confidence levels:
   - High: dedicated-server install, `server.cfg` auto-exec each map, `rcon_password` must match
     the launcher, `mp_gamemode versus` before `map`, direct `connect IP:27015`, port-forward UDP 27015.
   - Medium / **verify in-game**: `sv_allow_lobby_connect_only 0` and especially the
     **`sv_search_key` private-lobby method** (version-finicky). Direct connect is the reliable fallback.
3. **`rcon_password` must match** between `server.cfg` and `$RCON_PASSWORD` in `pick_mode.bat`
   (currently `alroker`). If the owner changes it, change both.

## Ideas / possible next steps (not started)

- A key-bind or in-game chat trigger to roll a mode without alt-tabbing to run the `.bat`.
- More modes (just add `cfg/mode_*.cfg` files — see Conventions).
- Per-map mode suggestions, or weighting random rolls by "Best on" map.
- Verify/firm up the lobby join flow and trim whichever join method proves unreliable.
