# CLAUDE.md

Full project context for AI agents lives in **[AGENTS.md](./AGENTS.md)** — read it first.
End-user setup and usage is in **[README.md](./README.md)**.

## Non-negotiable guardrails (also in AGENTS.md)

- **Target platform is Windows.** `pick_mode.bat` is PowerShell embedded in a `.bat`
  (keep the polyglot header). Don't add anything that only works on macOS/Linux.
- **Keep LF line endings** on all files (no CRLF/BOM) — current files are LF and work on
  the owner's Windows setup.
- **Add a mode by dropping `cfg/mode_<name>.cfg`** — the launcher auto-discovers `mode_*.cfg`
  at runtime. Never hardcode a mode list in `pick_mode.bat`.
- **`reset.cfg` / `current_mode.cfg` must stay non-`mode_*`** so they don't enter the rotation.
- Owner commits to `main` (personal repo). Commit/push only when asked.

See [AGENTS.md → Open items](./AGENTS.md#open-items--things-to-verify) for what still
needs verifying (the launcher hasn't been run on Windows yet; the README networking/lobby
sections are unverified).
