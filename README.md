# L4D2 Versus Modifier Modes

A collection of server-side cfg modifiers for Left 4 Dead 2 Versus. Each round a random modifier is applied via RCON to keep matches fresh and unpredictable.

## Modes

| # | Name | Effect |
|---|------|--------|
| 1 | Denser Horde | +30% common infected spawn limit |
| 2 | Tougher Commons | +20% common infected HP |
| 3 | Faster Commons | +15% common infected movement speed |
| 4 | Longer Smoker Reach | +25% Smoker tongue range |
| 5 | Punchier Hunter | +30% Hunter pounce damage |
| 6 | Heftier Tank | +25% Tank HP |
| 7 | More Frequent Tank | 80% Tank spawn chance per chapter |
| 8 | Witch Pressure | More witches, angrier, hit harder |
| 9 | Reduced Healing | Shorter adrenaline, tighter defib window |
| 10 | Tighter Ammo | ~25% less max ammo on all primaries |

## Usage

Run `pick_mode.bat` from the `versus_modes` folder:

```
pick_mode.bat           # random mode
pick_mode.bat 3         # specific mode by number
pick_mode.bat witch     # mode by keyword
pick_mode.bat tank      # lists all matches, prompts if ambiguous
```

`rcon.exe` ([gorcon v0.10.3](https://github.com/gorcon/rcon-cli)) must be placed in the same folder as `pick_mode.bat`.

Edit the config block at the top of `pick_mode.bat` to set your server IP, port, and RCON password.

## Beta

Modes in `cfg/beta/` are for internal testing and are not included in the random rotation.

## Reset

To restore all convars to defaults, run in the server console:
```
exec reset
```
