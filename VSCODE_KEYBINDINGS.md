# VS Code Keybindings Management

This document describes how VS Code keybindings are managed across macOS and Linux.

## Overview

VS Code stores keybindings in different locations on different operating systems:
- **macOS**: `~/Library/Application Support/Code/User/keybindings.json`
- **Linux**: `~/.config/Code/User/keybindings.json`

This setup keeps your custom keybindings in source control while allowing Linux to use the full macOS defaults as a base.

## Structure

```
vscode/
├── keybindings.json              # Your 7 custom keybindings (source of truth)
└── defaults/                     # Git submodule: codebling/vs-code-default-keybindings
    └── macos.keybindings.json    # Default macOS keybindings (with comments)

scripts/
└── sync-vscode-keybindings.sh    # Sync script for Linux, verification for macOS
```

## How It Works

### macOS
1. `install.sh` symlinks `vscode/keybindings.json` → `~/Library/Application Support/Code/User/keybindings.json`
2. Your custom keybindings are directly used by VS Code
3. Run `./scripts/sync-vscode-keybindings.sh` to verify the symlink is correct

### Linux
1. `install.sh` runs `./scripts/sync-vscode-keybindings.sh`
2. The script merges:
   - Default macOS keybindings (from submodule)
   - Your custom keybindings (from `vscode/keybindings.json`)
3. Result is written to `~/.config/Code/User/keybindings.json`
4. Custom keybindings override defaults with the same key binding

## Usage

### Initial Setup
```bash
./install.sh
```

This will:
- On macOS: Create symlink to your custom keybindings
- On Linux: Merge defaults with custom keybindings

### Adding New Custom Keybindings

1. Edit `vscode/keybindings.json` and add your new binding
2. Commit to git
3. On macOS: Changes are immediately available (symlinked)
4. On Linux: Run sync script to regenerate merged file:
   ```bash
   ./scripts/sync-vscode-keybindings.sh
   ```

### Updating Default Keybindings

The defaults come from the `codebling/vs-code-default-keybindings` repository via git submodule.

To update to the latest defaults:
```bash
git submodule update --remote vscode/defaults
```

Then on Linux, regenerate the merged keybindings:
```bash
./scripts/sync-vscode-keybindings.sh
```

### Detecting Local Modifications on Linux

If you add keybindings directly in VS Code on Linux (not in source control), the sync script will detect them:

```bash
./scripts/sync-vscode-keybindings.sh
```

The script will:
1. Detect keybindings in `~/.config/Code/User/keybindings.json` that aren't in `vscode/keybindings.json`
2. Prompt you to merge them into source control
3. If you choose to merge, they're added to `vscode/keybindings.json`
4. Review with `git diff vscode/keybindings.json` before committing

## Current Custom Keybindings

Your custom keybindings are:

```json
[
    { "key": "cmd+s", "command": "saveAll" },
    { "key": "alt+cmd+s", "command": "-saveAll" },
    { "key": "cmd+0", "command": "workbench.action.zoomReset" },
    { "key": "cmd+numpad0", "command": "-workbench.action.zoomReset" },
    { "key": "shift+cmd+0", "command": "workbench.action.focusSideBar" },
    { "key": "cmd+0", "command": "-workbench.action.focusSideBar" },
    { "key": "cmd+escape", "command": "github.copilot.completions.toggle" }
]
```

## Technical Details

### Comment Handling
The default keybindings file includes comments (lines starting with `//`). The sync script automatically strips these before processing with `jq`.

### Merge Logic
When merging defaults with custom keybindings:
1. Extract all unique key bindings from both files
2. For each key, use the custom version if it exists, otherwise use the default
3. This allows custom keybindings to override defaults

### Idempotency
- `install.sh` is idempotent and can be run multiple times safely
- `sync-vscode-keybindings.sh` can be run anytime to regenerate the merged file on Linux

