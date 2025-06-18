# Starship Prompt Toggle System

This dotfiles setup includes a flexible prompt toggle system that allows you to quickly switch between different Starship prompt configurations depending on your needs.

## Available Configurations

### 🚀 Full Prompt (`starship.toml`)
- **Features**: Time, Git info, Languages, Cloud tools, System info, Memory usage
- **Best for**: Development work, full context needed
- **Lines**: 2 lines (info line + prompt line)

### 📦 Minimal Prompt (`starship-minimal.toml`)
- **Features**: Hostname, Directory, Basic git info
- **Best for**: Clean look while keeping essential info
- **Lines**: 1 line

### ➡️ Single-Line Prompt (`starship-single.toml`)
- **Features**: Directory, Git status
- **Best for**: Maximum screen real estate, focused work
- **Lines**: 1 line

### ⚡ Super Minimal Prompt (`starship-super-minimal.toml`)
- **Features**: Just directory and prompt symbol
- **Best for**: Absolute minimal distraction
- **Lines**: 1 line

## Quick Commands

### Functions (Full Names)
```bash
prompt-full           # Switch to full-featured prompt
prompt-minimal        # Switch to minimal prompt
prompt-single         # Switch to single-line prompt
prompt-super-minimal  # Switch to super minimal prompt
prompt-reset          # Reset to default Starship config
prompt-status         # Show current configuration
prompt-list           # List all available configurations
```

### Usage Notes
- Functions automatically reinitialize Starship with the new configuration
- Changes take effect immediately in the current shell
- Configuration persists across new terminal sessions

## How It Works

The system uses the `STARSHIP_CONFIG` environment variable to point to different configuration files:

1. **Configuration Files**: Located in `~/.zsh/` directory
2. **Environment Variable**: `STARSHIP_CONFIG` points to the active config
3. **Shell Reload**: Each switch reloads zsh to apply changes immediately

## Examples

```bash
# Switch to minimal for focused coding
pm

# Check current configuration
pst

# Switch to super minimal for presentations
psm

# Back to full-featured for development
pf

# List all options
pls
```

## Customization

You can modify any of the configuration files in `~/.zsh/`:
- `starship.toml` - Full configuration
- `starship-minimal.toml` - Minimal configuration
- `starship-single.toml` - Single-line configuration
- `starship-super-minimal.toml` - Super minimal configuration

Or create your own configuration file and use:
```bash
export STARSHIP_CONFIG=~/.zsh/your-custom-config.toml
exec zsh
```

## Tips

1. **Quick Status**: Use `pst` to see which configuration is currently active
2. **Help**: Use `pls` to see all available options
3. **Reset**: Use `pr` if you want to go back to the default Starship behavior
4. **Persistence**: The configuration persists across terminal sessions
5. **Performance**: Minimal configurations load faster and use less resources
