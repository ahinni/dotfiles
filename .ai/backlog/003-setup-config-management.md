# Task 000: Setup .config Directory Management

## Overview
Establish proper management of the `~/.config` directory and its subdirectories within the dotfiles system. This is foundational work that must be completed before modernizing bash configuration, as it affects editor choices and tool configurations.

## Current State Analysis

### Existing .config Contents (Audited)
```
~/.config/
├── configstore/    # npm/yarn cache - AUTO-GENERATED, skip
├── fish/          # Fish shell - NOT USING (moving to zsh)
├── gh/            # GitHub CLI - SAFE to manage
│   ├── config.yml     # Preferences only, no secrets
│   └── hosts.yml      # Username + protocol, safe
├── iterm2/        # iTerm2 - SYMLINKS ONLY, skip for now
│   └── AppSupport -> /Users/aaron/Library/Application Support/iTerm2
├── nvim/          # Neovim - SAFE, newly setup ⭐ PRIORITY
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── lua/
│   └── after/
└── op/            # 1Password CLI - SENSITIVE, never include
    ├── config         # Contains device IDs and auth tokens
    └── op-daemon.sock
```

### Current Editor Inconsistency Issues
- ✅ `alias vi='nvim'` - Correctly redirects vi to nvim
- ❌ `alias ali='vim ~/.dotfiles/bash/aliases'` - Uses vim directly
- ❌ `alias no='vim ~/Dropbox/aaron/notes.txt'` - Uses vim directly
- ❌ `alias todo='vim ~/Dropbox/aaron/todo.txt'` - Uses vim directly
- ❌ `alias vack='vi ~/.ackrc'` - Uses vi (which redirects to nvim, but inconsistent)

### Missing from Dotfiles Management
- `~/.config/nvim/` - Your primary editor configuration (newly setup, perfect timing!)
- `~/.config/gh/` - GitHub CLI settings (safe preferences only)

## Strategy: Individual Subdirectory Management

**KEY INSIGHT**: `~/.config` is a **standard directory** used by many applications following XDG Base Directory Specification. We should:

1. **Respect the standard**: `~/.config` is created by apps as needed
2. **Link individual subdirectories**: Not the whole `.config` directory
3. **Coexist peacefully**: Leave other apps' configs untouched

### Our Approach:
```
~/.config/                    # Standard directory (may or may not exist)
├── nvim/ -> ~/.dotfiles/config/nvim/     # OUR symlink
├── gh/ -> ~/.dotfiles/config/gh/         # OUR symlink
├── configstore/              # Leave alone (npm/yarn)
├── op/                       # Leave alone (1Password)
├── iterm2/                   # Leave alone (just symlinks anyway)
└── fish/                     # Leave alone (not using)
```

### Include in Dotfiles:
- ✅ **nvim/**: Your new Neovim config (safe, newly setup)
- ✅ **gh/**: GitHub CLI preferences (audited, no secrets)

### Leave Untouched:
- 🤝 **op/**: 1Password CLI (other app's responsibility)
- 🤝 **configstore/**: npm/yarn cache (other app's responsibility)
- 🤝 **iterm2/**: Just symlinks to Application Support
- 🤝 **fish/**: Not using, but not our concern

## Tasks

### Task 0.1: Create Comprehensive Backup Strategy
- [ ] **CRITICAL**: Create timestamped backup of entire `~/.config/`
  ```bash
  cp -r ~/.config ~/.config.backup.$(date +%Y%m%d_%H%M%S)
  ```
- [ ] Document current state with file listings
- [ ] Verify backup integrity before proceeding
- [ ] Create rollback plan if anything goes wrong

### Task 0.2: Setup Safe .config Structure in Dotfiles
- [ ] Create `config/` directory in dotfiles root
- [ ] **COPY** (don't move yet) `~/.config/nvim/` to `dotfiles/config/nvim/`
- [ ] **COPY** (don't move yet) `~/.config/gh/` to `dotfiles/config/gh/`
- [ ] Verify copied configs work independently
- [ ] Test nvim with copied config before linking

### Task 0.3: Create Safe install.sh Logic for .config
- [ ] Add `.config` subdirectory linking function with safety checks
- [ ] **Always backup existing configs** before linking
- [ ] Create `~/.config/` if it doesn't exist
- [ ] Link individual subdirectories (never the whole .config)
- [ ] Add verification that links work correctly
- [ ] Include rollback functionality

### Task 0.4: Implement Gradual Migration Process
- [ ] **Phase 1**: Test nvim config linking only
- [ ] **Phase 2**: Add gh config linking after nvim verified
- [ ] **Phase 3**: Verify all tools work with new setup
- [ ] **Phase 4**: Clean up original files only after full verification

### Task 0.5: Standardize Editor References (After Safe Migration)
- [ ] Audit all files for editor references
- [ ] Standardize on `nvim` for direct calls
- [ ] Update aliases to use `$EDITOR` variable
- [ ] Set `EDITOR` and `VISUAL` environment variables properly

### Task 0.6: Comprehensive Testing and Verification
- [ ] Test nvim launches and loads config correctly
- [ ] Test gh CLI functions with new config location
- [ ] Verify no functionality is lost
- [ ] Test install.sh on clean system (if possible)
- [ ] Document any issues and solutions

## Proposed File Structure

```
dotfiles/
├── config/
│   ├── nvim/           # Neovim configuration (copied from ~/.config/nvim/)
│   └── gh/             # GitHub CLI config (copied from ~/.config/gh/)
├── bash/
├── zsh/
├── .gitignore          # Updated to exclude sensitive configs
└── install.sh          # Updated with safe config linking
```

## Safety-First .gitignore Additions

```gitignore
# Sensitive .config directories (never commit these)
config/op/
config/configstore/

# Backup files
*.backup.*
.config.backup.*

# OS and editor files
.DS_Store
*.swp
*.swo
*~
```

## install.sh Modifications Needed

### Add Safe .config Subdirectory Linking Function
```bash
# Function to safely link individual .config subdirectories
link_config_dir() {
  local config_dir=$1
  local source_path="$DOTFILES_DIR/config/$config_dir"
  local target_path="$HOME/.config/$config_dir"

  # Ensure source exists
  if [ ! -d "$source_path" ]; then
    echo "⚠️  Source config not found: $source_path"
    return 1
  fi

  # Create ~/.config directory if it doesn't exist (standard XDG location)
  if [ ! -d "$HOME/.config" ]; then
    echo "Creating ~/.config directory (XDG standard)"
    mkdir -p "$HOME/.config"
  fi

  # Safety check: backup existing config if it exists and isn't already our symlink
  if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    local backup_path="${target_path}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "📦 Backing up existing $target_path to $backup_path"
    mv "$target_path" "$backup_path"
  elif [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    echo "✅ ~/.config/$config_dir is already linked correctly"
    return 0
  elif [ -L "$target_path" ]; then
    echo "⚠️  ~/.config/$config_dir is a symlink to $(readlink "$target_path")"
    echo "    Will replace with our dotfiles version"
    rm "$target_path"
  fi

  # Create the symlink
  echo "🔗 Linking ~/.config/${config_dir} -> $source_path"
  ln -sf "$source_path" "$target_path"

  # Verify the link was created successfully
  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    echo "✅ Successfully linked ~/.config/$config_dir"
    return 0
  else
    echo "❌ Failed to link ~/.config/$config_dir"
    return 1
  fi
}

# In main installation function - add this after the main dotfiles loop
echo ""
echo "🔧 Setting up .config subdirectory management..."
if [ -d "$DOTFILES_DIR/config" ]; then
  config_success=true
  for config_subdir in "$DOTFILES_DIR/config"/*; do
    if [ -d "$config_subdir" ]; then
      subdir_name=$(basename "$config_subdir")
      echo "Processing config subdirectory: $subdir_name"
      if ! link_config_dir "$subdir_name"; then
        config_success=false
      fi
    fi
  done

  if [ "$config_success" = true ]; then
    echo "✅ All .config subdirectories linked successfully"
  else
    echo "⚠️  Some .config subdirectories failed to link"
  fi
else
  echo "ℹ️  No config directory found in dotfiles, skipping .config setup"
fi
echo ""
```

## Editor Standardization Plan

### Environment Variable
```bash
# In bash/config or equivalent
export EDITOR="nvim"
export VISUAL="nvim"
```

### Alias Standardization
```bash
# Consistent editor aliases
alias vi='nvim'
alias vim='nvim'
alias edit='nvim'

# Update existing aliases to use $EDITOR
alias ali='$EDITOR ~/.dotfiles/bash/aliases'
alias no='$EDITOR ~/Dropbox/aaron/notes.txt'
alias todo='$EDITOR ~/Dropbox/aaron/todo.txt'
```

## Safe Migration Steps (COPY-FIRST Approach)

### Step 1: Create Comprehensive Backup
```bash
# Create timestamped backup of entire .config
cp -r ~/.config ~/.config.backup.$(date +%Y%m%d_%H%M%S)

# Verify backup was created
ls -la ~/.config.backup.*

# Document current state
find ~/.config -type f > ~/.config.inventory.$(date +%Y%m%d_%H%M%S)
```

### Step 2: Setup Dotfiles Structure (COPY, don't move)
```bash
# Create config directory in dotfiles
mkdir -p ~/.dotfiles/config

# COPY (don't move) nvim config
cp -r ~/.config/nvim ~/.dotfiles/config/nvim

# COPY (don't move) gh config
cp -r ~/.config/gh ~/.dotfiles/config/gh

# Verify copies are complete
diff -r ~/.config/nvim ~/.dotfiles/config/nvim
diff -r ~/.config/gh ~/.dotfiles/config/gh
```

### Step 3: Test Copied Configs Work
```bash
# Test nvim with copied config (temporarily)
NVIM_APPNAME=test-nvim cp -r ~/.dotfiles/config/nvim ~/.config/test-nvim
nvim --cmd "set runtimepath^=~/.config/test-nvim" +q
rm -rf ~/.config/test-nvim
```

### Step 4: Update install.sh with Safety Features
- Add the safe linking function (from above)
- Test install.sh changes on a test directory first
- Add rollback functionality

### Step 5: Gradual Linking (One Config at a Time)
```bash
# Link nvim first (test thoroughly)
cd ~/.dotfiles
./install.sh  # Should link nvim config

# Test nvim extensively
nvim --version
nvim +checkhealth +q

# Only proceed to gh if nvim works perfectly
```

### Step 6: Final Verification and Cleanup
```bash
# Verify all tools work correctly
nvim +q  # Should start without errors
gh --version  # Should work with config

# Only after everything works: remove originals
# rm -rf ~/.config/nvim.original
# rm -rf ~/.config/gh.original
```

## Benefits of This Approach

### Consistency
- Single source of truth for editor choice
- Consistent aliases across all files
- Proper environment variable setup

### Portability
- nvim configuration travels with dotfiles
- GitHub CLI settings preserved
- Easy setup on new machines

### Maintainability
- Version control for important configs
- Easy to track changes
- Backup and restore capabilities

## Risks and Mitigations

### Risk: Breaking Current Nvim Setup
- **Mitigation**: COPY-FIRST approach (never move until verified)
- **Mitigation**: Timestamped backups with verification
- **Mitigation**: Test copied configs before linking
- **Mitigation**: Gradual migration (nvim first, then gh)

### Risk: Losing Work in Progress
- **Mitigation**: Your nvim config is new (minimal risk)
- **Mitigation**: Multiple backup layers
- **Mitigation**: Document current state before changes
- **Mitigation**: Easy rollback with backup restoration

### Risk: Sensitive Data Exposure
- **Mitigation**: Audited configs (gh/ contains no secrets)
- **Mitigation**: Explicit .gitignore for sensitive directories
- **Mitigation**: Never include op/ or configstore/

### Risk: Tool-Specific Config Requirements
- **Mitigation**: Test each tool after linking
- **Mitigation**: Verify symlinks work correctly
- **Mitigation**: Document any special requirements discovered

### Risk: Install Script Breaking Existing Setup
- **Mitigation**: Automatic backup before any changes
- **Mitigation**: Verification checks after each link
- **Mitigation**: Rollback functionality built-in

## Dependencies
- None (this is foundational)

## Estimated Time
- 1-2 hours for complete setup
- Additional time for nvim configuration if needed

## Success Criteria
- [ ] **SAFETY**: Complete backup of current .config created and verified
- [ ] **FUNCTIONALITY**: nvim works identically after migration
- [ ] **FUNCTIONALITY**: gh CLI works identically after migration
- [ ] **INTEGRATION**: install.sh safely handles .config subdirectories
- [ ] **CONSISTENCY**: Editor references standardized across all files
- [ ] **PORTABILITY**: Configs work on fresh system installation
- [ ] **SECURITY**: No sensitive data committed to version control

## Rollback Plan (If Anything Goes Wrong)
```bash
# Stop immediately and restore from backup
rm -rf ~/.config
cp -r ~/.config.backup.YYYYMMDD_HHMMSS ~/.config

# Verify restoration
nvim +q  # Should work as before
gh --version  # Should work as before

# Remove problematic dotfiles changes
rm -rf ~/.dotfiles/config
git checkout HEAD -- install.sh  # If modified
```

## Notes
- **SAFETY FIRST**: This approach prioritizes not breaking your current setup
- **Your nvim config is new**: Perfect timing to get it under version control
- **Copy-first approach**: Never move/delete until everything is verified working
- **Gradual migration**: One config at a time, test thoroughly
- **This task sets foundation**: Tasks 001 and 002 depend on clean editor setup
- **Document everything**: Keep notes of what works and what doesn't
