# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for setting up development environments on macOS and Linux. Configuration files live in `home/` and get symlinked to the home directory.

## Commands

### Installation
```bash
./install.sh                              # Install/update dotfiles (symlinks home/* to ~/.*)
./test-dotfiles.sh                        # Test installation in Docker container first
```

### VS Code Keybindings
```bash
./scripts/sync-vscode-keybindings.sh      # Sync keybindings (Linux merges defaults; macOS verifies symlink)
```

### Git Submodules
```bash
git submodule update --init               # Initialize submodules (VS Code defaults)
git submodule update --remote             # Update to latest versions
```

## Architecture

### Directory Structure
- **`home/`** - All active dotfiles; everything here gets symlinked to `~/.*`
- **`home/config/`** - XDG config directories; symlinked to `~/.config/*`
- **`home/bash/`** - Bash-specific modules (aliases, functions, paths, completions)
- **`home/zsh/`** - Zsh-specific modules with Zinit plugin manager and Starship prompt configs
- **`home/shell/`** - Shared bash/zsh functions
- **`vscode/`** - VS Code keybindings management with git submodule for defaults
- **`scripts/`** - Utility scripts (keybindings sync, GNOME setup)
- **`archive/`** - Deprecated configs (oh-my-zsh, janus vim)

### Shell Setup
- Primary shell: Zsh with Zinit + Starship prompt
- Modular config: separate files for aliases, functions, paths, history, completions
- Both bash and zsh share some functions via `home/shell/functions`
- Multiple Starship prompt configs available (`starship.toml`, `starship-minimal.toml`, etc.)

### Platform Handling
- macOS: VS Code keybindings symlinked directly
- Linux: VS Code keybindings merged with macOS defaults, GNOME keybindings configured
- Apple Silicon: checks `/opt/homebrew` first, falls back to `/usr/local`

### Adding New Dotfiles
1. Place file in `home/` (or directory in `home/config/` for XDG)
2. Run `./install.sh` - no ignore lists or script changes needed

### Installation Behavior
- Prompts before overwriting existing files (y/n/a/q)
- Creates backups of existing `.config` directories with timestamps
- Skips already-correctly-linked files
- Creates `~/.tmp` directory
