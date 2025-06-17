# Aaron Hinni's Dotfiles

These are configuration files to set up a system the way I like it.
Borrowed heavily from [r00k/dotfiles](https://github.com/r00k/dotfiles) and the original rbates dotfiles.

## Installation

```bash
git clone https://github.com/ahinni/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## What's Included

This dotfiles repository includes configurations for:

- **Bash** - Aliases, functions, and shell configuration
- **Zsh** - Oh-my-zsh setup with custom themes and plugins
- **Git** - Global gitconfig and gitignore settings
- **Vim** - Janus-based vim configuration with custom plugins
- **Tmux** - Terminal multiplexer configuration
- **Various tools** - ack, jshint, rails, irb, and more

## Features

- **Safe Installation**: The install script prompts before overwriting existing files
- **Symbolic Links**: Creates symlinks to keep your dotfiles in sync
- **Modular**: Easy to add or remove specific configurations
- **Cross-platform**: Works on macOS and Linux

## Usage

The installation script will:
1. Create symbolic links from your home directory to the dotfiles
2. Prompt you before overwriting any existing files
3. Skip files with "ignore" in the name
4. Create a `~/.tmp` directory for temporary files

### Options during installation:
- `y` - Yes, overwrite the file
- `n` - No, skip this file
- `a` - Yes to all remaining files
- `q` - Quit installation

## Customization

Feel free to fork this repository and customize it for your own needs. The configuration is modular, so you can easily:
- Add new dotfiles by placing them in the root directory
- Remove configurations by adding "ignore" to the filename
- Modify existing configurations to match your preferences

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
