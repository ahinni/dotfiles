# Aaron Hinni's Dotfiles

These are configuration files to set up a system the way I like it.
Borrowed heavily from [r00k/dotfiles](https://github.com/r00k/dotfiles) and the original rbates dotfiles.

## Installation

### Prerequisites

This dotfiles setup requires some tools to be installed via Homebrew:

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install zsh starship fzf

# Optional tools for enhanced experience
brew install zoxide bat exa
```

### Install Dotfiles

```bash
git clone https://github.com/ahinni/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh

# Switch to zsh (if not already default)
chsh -s $(which zsh)
```

## Repository Structure

This repository uses a clean, organized structure that separates project files from dotfiles:

```
dotfiles/
├── README.md                    # Project documentation
├── install.sh                   # Installation script
├── test-dotfiles.sh            # Docker testing script
├── .ai/                         # Task management
├── home/                        # 🌟 ALL ACTIVE DOTFILES
│   ├── bash_profile             # Shell configurations
│   ├── zshrc, zlogin
│   ├── gitconfig, gitignore_global  # Git settings
│   ├── tmux.conf               # Terminal multiplexer
│   ├── vimrc.*, gvimrc.*       # Vim configurations
│   ├── ackrc, jshintrc, etc.   # Tool configurations
│   ├── bash/                   # Bash-specific configs
│   │   ├── aliases, functions, paths
│   │   └── completion_scripts/
│   ├── zsh/                    # Zsh-specific configs
│   │   ├── aliases, functions
│   └── config/                 # XDG config directories
│       ├── nvim/               # Neovim configuration
│       └── gh/                 # GitHub CLI config
└── archive/                    # 📦 ARCHIVED CONFIGS
    ├── oh-my-zsh/             # Legacy zsh setup
    ├── janus/                 # Legacy vim setup
    └── vim.ignore/            # Old vim configs
```

## What's Included

This dotfiles repository includes configurations for:

- **Bash** - Modernized aliases, functions, paths, and shell configuration
- **Zsh** - Modern zsh setup with Zinit plugin manager, Starship prompt, syntax highlighting, and autosuggestions
- **Git** - Global gitconfig and gitignore settings with enhanced aliases
- **Vim/Neovim** - Editor configurations (active and archived)
- **Tmux** - Terminal multiplexer configuration
- **Various tools** - ack, jshint, rails, irb, kubectl, docker, and more
- **XDG Config** - Support for ~/.config subdirectories

## Features

- **Clean Architecture**: Clear separation between project files and dotfiles
- **Safe Installation**: The install script prompts before overwriting existing files
- **Symbolic Links**: Creates symlinks to keep your dotfiles in sync
- **Modular**: Easy to add or remove specific configurations
- **XDG Config Support**: Handles ~/.config subdirectories properly
- **Cross-platform**: Works on macOS and Linux
- **Docker Testing**: Test installations safely in containers

## Usage

The installation script will:
1. Process all files and directories in the `home/` directory
2. Create symbolic links from your home directory to the dotfiles
3. Handle `.config` subdirectories by linking them to `~/.config/`
4. Prompt you before overwriting any existing files
5. Create a `~/.tmp` directory for temporary files

### Installation Options:
- `y` - Yes, overwrite the file
- `n` - No, skip this file
- `a` - Yes to all remaining files
- `q` - Quit installation

### Testing Before Installation

You can safely test the installation process using Docker:

```bash
./test-dotfiles.sh
```

This will build a test container and let you interactively test the installation process without affecting your actual system.

## Adding New Dotfiles

The new structure makes adding dotfiles incredibly simple:

1. **For regular dotfiles**: Just place them in the `home/` directory
2. **For .config subdirectories**: Place them in `home/config/`
3. **Run installation**: `./install.sh` - no ignore lists needed!

Examples:
```bash
# Add a new dotfile
cp ~/.newconfig home/newconfig

# Add a new .config subdirectory
cp -r ~/.config/myapp home/config/myapp

# Install the changes
./install.sh
```

## Migration from Old Structure

If you're migrating from an older version of this dotfiles repository, use the included migration script:

```bash
./migrate-to-home-structure.sh
```

This script will:
- Create a backup of your current setup
- Safely migrate to the new structure
- Verify everything works correctly
- Provide rollback capability if needed

## Customization

Feel free to fork this repository and customize it for your own needs. The configuration is modular and well-organized:

- **Active configs**: Modify files in `home/` directory
- **Shell-specific**: Edit `home/bash/` or `home/zsh/` directories
- **Tool configs**: Individual files in `home/` for specific tools
- **Archive old configs**: Move unused configs to `archive/` directory

## Architecture Benefits

The new `home/` structure provides several advantages:

### 🎯 **Simplicity**
- **No ignore lists**: Everything in `home/` gets linked automatically
- **Clear organization**: Project files vs dotfiles vs archived configs
- **Easy maintenance**: Adding new dotfiles requires no script changes

### 🛡️ **Safety**
- **Docker testing**: Test changes safely before applying to your system
- **Migration scripts**: Safe transition with backup and rollback
- **Verification**: Built-in checks to ensure everything works

### 🚀 **Maintainability**
- **Clean git history**: Separate commits for project vs config changes
- **Future-proof**: Structure scales well as configs grow
- **Self-documenting**: Directory structure makes purpose clear

## Troubleshooting

### Symlinks Not Working
```bash
# Check if symlinks point to the right location
ls -la ~/.gitconfig
# Should show: ~/.gitconfig -> /path/to/dotfiles/home/gitconfig

# Re-run installation if needed
./install.sh
```

### Migration Issues
```bash
# Check migration backup
ls ~/.dotfiles-migration-backup-*

# Manual rollback if needed (replace TIMESTAMP with actual backup)
cd ~/.dotfiles-migration-backup-TIMESTAMP
# Follow the symlinks.txt file to restore manually
```

### Testing Changes
```bash
# Always test in Docker first
./test-dotfiles.sh

# Or test specific functionality
git config --list  # Test git config
source ~/.bash_profile  # Test bash config
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
