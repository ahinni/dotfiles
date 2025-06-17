# Modern Zsh Setup - Usage Guide

This document provides a comprehensive guide to using the modern zsh configuration that was implemented in Task 002.

## 🚀 Quick Start

### Required Tools
```bash
# Install required tools
brew install zsh starship fzf

# Optional tools for enhanced experience
brew install zoxide bat exa
```

### Switch to Zsh
```bash
# Check current shell
echo $SHELL

# Switch to modern zsh (if needed)
chsh -s $(which zsh)
```

## 🧪 Testing Your New Features

### 1. Syntax Highlighting
Commands are colored as you type to show validity:

```bash
# Type these and watch the colors change
git status          # Valid command = green
git statuss         # Invalid command = red
ls -la             # Valid options = green
kubectl get pods   # Valid kubectl command = green
```

### 2. Autosuggestions
Fish-like suggestions based on your command history:

```bash
# Start typing a command you've used before
git st...          # Should show gray suggestion like "git status"
cd /usr/lo...      # Should suggest "/usr/local"

# Press → (right arrow) to accept suggestion
# Press Ctrl+F to accept suggestion
```

### 3. Enhanced Tab Completion
Smart, context-aware completions:

```bash
# Try these with TAB
git <TAB>          # Shows git subcommands
git checkout <TAB> # Shows available branches
kubectl <TAB>      # Shows kubectl commands
kubectl get <TAB>  # Shows resource types
cd /usr/lo<TAB>    # Completes to /usr/local
docker <TAB>       # Shows docker commands
```

### 4. Global Aliases (Zsh-Specific)
Powerful aliases that work anywhere in the command line:

```bash
# These work at the end of any command
ls | G something   # G = | grep
ls | L             # L = | less
ls | H             # H = | head
ls | T             # T = | tail
ls | S             # S = | sort
ls | U             # U = | uniq
ls | C             # C = | wc -l (count lines)
command N          # N = > /dev/null 2>&1 (silence output)
```

### 5. Enhanced Navigation
Smart directory navigation features:

```bash
# Auto-cd (just type directory name, no 'cd' needed)
/usr/local         # Automatically changes to /usr/local
..                 # Go up one directory
...                # Go up two directories
....               # Go up three directories

# Directory stack management
d                  # Show directory stack with numbers
1                  # Go to previous directory (cd -)
2                  # Go to 2nd directory in stack
3                  # Go to 3rd directory in stack
- or cd -          # Toggle between current and previous directory
```

### 6. Advanced History Features
Enhanced command history with search:

```bash
# History search (if fzf is installed)
fh                 # Fuzzy search through command history

# Arrow key history search
↑ ↓               # Navigate through history
# Start typing, then ↑ ↓ to search history for commands starting with what you typed

# History expansion
!!                 # Repeat last command
!git               # Repeat last command starting with 'git'
!?status           # Repeat last command containing 'status'
```

### 7. Git Integration
Enhanced git workflow with better status and operations:

```bash
# Enhanced git aliases
gst                # git status --short --branch (compact status)
glog               # git log --oneline --decorate --graph
gloga              # git log --oneline --decorate --graph --all
gtree              # Beautiful git tree view
gclean             # Clean up merged branches

# Git functions
g                  # git status (if no args), or git <args>
g add .            # Same as git add .
g                  # Shows git status
```

### 8. Development Tools
Enhanced completions and aliases for development:

```bash
# Kubernetes
k                  # Alias for kubectl
kc                 # Switch kubectl context
kubeshell app-name # Get shell in pod by app name

# Docker
d                  # Alias for docker
dc                 # Alias for docker-compose
dps                # docker ps
dpsa               # docker ps -a

# Node.js
ni                 # npm install
nid                # npm install --save-dev
nig                # npm install -g
nt                 # npm test
```

## 🎨 Starship Prompt Features

The Starship prompt shows contextual information:

### What You'll See
- **Current directory** with smart truncation
- **Git branch and status** with symbols:
  - `🌱 main` - Current branch
  - `✓` - Clean working directory
  - `📝` - Modified files
  - `🤷` - Untracked files
  - `📦` - Stashed changes
- **Language versions** (Node.js 🤖, Python 🐍, Ruby 💎, etc.)
- **Cloud context** (AWS ☁️, Kubernetes ⛵)
- **Command duration** for long-running commands
- **Exit status** indicators

### Customization
Edit the prompt configuration:
```bash
nvim ~/.zsh/starship.toml
```

## ⚡ Performance Features

### Lazy Loading
Heavy tools load only when needed:

```bash
# These tools lazy-load on first use
nvm                # Node Version Manager
rvm                # Ruby Version Manager
```

### Startup Profiling
Check your shell startup time:

```bash
# Time your shell startup
time zsh -i -c exit

# Enable profiling (uncomment in ~/.zshrc)
# zmodload zsh/zprof  # at top
# zprof               # at bottom
```

## 🛠 Customization

### Configuration Files
- **Main config**: `~/.zshrc` (symlinked to dotfiles)
- **Zsh options**: `~/.zsh/config`
- **Aliases**: `~/.zsh/aliases`
- **Functions**: `~/.zsh/functions`
- **Completions**: `~/.zsh/completions`
- **History**: `~/.zsh/history_config`
- **Prompt**: `~/.zsh/starship.toml`

### Quick Edit Aliases
```bash
zrc                # Edit ~/.zshrc
zconf              # Edit ~/.zsh/config
ali                # Edit ~/.zsh/aliases
zali               # Edit ~/.zsh/aliases (zsh-specific)
bali               # Edit ~/.bash/aliases (bash version)
so                 # Source ~/.zshrc (reload config)
```

### Adding Custom Aliases
```bash
# Edit the aliases file
ali

# Add your custom aliases, then reload
so
```

## 🔧 Troubleshooting

### Plugin Issues
```bash
# Reinstall zinit and plugins
rm -rf ~/.local/share/zinit
# Restart terminal (zinit will auto-install)
```

### Completion Issues
```bash
# Rebuild completion cache
rm ~/.zcompdump*
# Restart terminal
```

### Performance Issues
```bash
# Profile startup time
time zsh -i -c exit

# Enable detailed profiling
# Uncomment zprof lines in ~/.zshrc
```

### Reset to Defaults
```bash
# Backup your customizations
cp ~/.zsh/aliases ~/.zsh/aliases.backup

# Reset from dotfiles
cd ~/dotfiles
./install.sh
```

## 📚 Advanced Features

### FZF Integration (if installed)
```bash
# Fuzzy file search
Ctrl+T             # Insert selected files/directories

# Fuzzy directory change
Alt+C              # cd into selected directory

# Fuzzy history search
Ctrl+R             # Search command history

# Custom functions
ff                 # Fuzzy find files with preview
fh                 # Fuzzy search command history
```

### Zoxide Integration (if installed)
```bash
# Smart directory jumping
z project          # Jump to directory containing "project"
zi                 # Interactive directory selection
```

## 🎯 Tips and Tricks

### Productivity Boosters
1. **Use global aliases**: `ls | G pattern` instead of `ls | grep pattern`
2. **Auto-cd**: Just type directory names instead of `cd dirname`
3. **Directory stack**: Use `d` and numbers to jump between directories
4. **History search**: Start typing and use ↑ to find previous commands
5. **Tab completion**: Use TAB liberally for commands, files, and options

### Workflow Improvements
1. **Git workflow**: Use `gst` for quick status, `glog` for history
2. **Kubernetes**: Use `k` for kubectl, `kc` to switch contexts
3. **Docker**: Use `d` for docker, `dc` for docker-compose
4. **File editing**: Use `e` to quickly edit files or directories

### Learning More
- **Zsh manual**: `man zsh`
- **Starship docs**: https://starship.rs/
- **FZF usage**: https://github.com/junegunn/fzf
- **Zinit docs**: https://github.com/zdharma-continuum/zinit

## 🚀 Next Steps

1. **Practice the features** listed above
2. **Customize aliases** and functions for your workflow
3. **Install optional tools** (zoxide, bat, exa) for enhanced experience
4. **Explore Starship modules** for additional prompt information
5. **Add custom completions** for tools you use frequently

Enjoy your modern, powerful zsh setup! 🎉
