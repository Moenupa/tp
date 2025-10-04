# tp: Orchestrate from Boilerplates

`template` (alias: `tp`) is a lightweight cmdline helper to materialize boilerplate files from a personal template tree stored under `~/.template/<ext>/<name>`.  
Without flags it prints the template to stdout; with `-w` it writes `./<name>.<ext>` safely (refuses to overwrite).

## Features
- Flat, human-readable directory layout grouped by extension.
- Zsh completion, enumerates available `<ext>/<name>` pairs.
- Minimal, dependency-free (pure shell).

## Directory Layout
Place templates like:
```
~/.template/
├── py
│   ├── minjson
│   ├── printdf
│   └── reformat
├── sbatch
│   ├── job
│   └── matrix
└── yaml
    └── pre-commit-config
```
Calling `tp py/script` prints `~/.template/py/script`.  
`tp -w py/script` creates `./script.py`.

## Installation
1. In `.zshrc`:
   ```zsh
   source /home/meng_wang/.template/template.zsh
   ```
2. Reload shell.

The function defines both `template` and the alias `tp`.

## Usage
```
tp [-w|--write] <ext>/<name>
tp -h
```
Arguments:
- `<ext>/<name>`  Required spec pointing to `~/.template/<ext>/<name>`
Options:
- `-w` Write to `./<name>.<ext>`
- `-h` Help

## Examples
Preview:
```
tp py/script
```
Write (fails if `./script.py` exists):
```
tp -w py/script
```
Generate a Markdown scaffold:
```
tp -w md/doc
```
Pipe through a processor:
```
tp sh/init | sed 's/PROJECT/foo/'
```

## Completion
Press <Tab> after starting `tp ` to see available specs.  
Completion lists every file under `~/.template/*/*`.

## Exit Codes
0 success
1 usage / template missing / destination exists
(other) copy error

## Tips
- Make executable templates (e.g., `chmod +x ~/.template/sh/init`) if you often copy scripts.
- Keep templates free of extensions in their stored form; the utility appends `.<ext>` only on write.
- Use version control on `~/.template` to sync across machines.

## Updating Templates
Edit the source under `~/.template`; no cache is kept.

## Uninstall
Remove or comment out the `source` line and delete `.template` if desired.
