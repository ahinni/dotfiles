# Task 000: Restructure Dotfiles Architecture

## Overview
Reorganize the dotfiles repository to have a clean separation between project management files and actual dotfiles. This eliminates the fragile ignore list in install.sh and creates a more maintainable structure.

## Current Problems

### Fragile Mixed Structure
```
dotfiles/
├── README.md           # Project file (manually ignored)
├── install.sh          # Project file (manually ignored)
├── bash_profile        # Dotfile (gets linked)
├── gitconfig           # Dotfile (gets linked)
├── bash/               # Dotfile dir (gets linked)
├── oh-my-zsh/          # Project dependency (manually ignored)
├── vim.ignore/         # Old config (manually ignored)
├── .ai/                # Task management (manually ignored)
└── Dockerfile.test     # Project file (manually ignored)
```

### Growing Ignore List Problem
```bash
# install.sh has to manually ignore more and more files
if [[ "$file" == "Rakefile" || "$file" == "README.md" || "$file" == "LICENSE" ||
      "$file" == "id_dsa.pub" || "$file" == "install.sh" ||
      "$file" == "Dockerfile.test" || "$file" == "test-dotfiles.sh" ||
      "$file" == ".ai" ]]; then
  continue
fi
```

## Proposed Clean Architecture

### New Structure
```
dotfiles/
├── README.md                    # Project documentation
├── install.sh                   # Installation script
├── .gitignore                   # Project config
├── .ai/                         # Task management
│   └── backlog/
├── home/                        # ALL DOTFILES HERE ⭐
│   ├── bash_profile
│   ├── bash_logout
│   ├── zshrc
│   ├── zlogin
│   ├── gitconfig
│   ├── gitignore_global
│   ├── tmux.conf
│   ├── ackrc
│   ├── gemrc
│   ├── irbrc
│   ├── railsrc
│   ├── rdebugrc
│   ├── screenrc
│   ├── jshintrc
│   ├── jsl.vim.conf
│   ├── gvimrc.after
│   ├── gvimrc.before
│   ├── vimrc.after
│   ├── vimrc.before
│   ├── bash/                    # Bash configuration
│   │   ├── aliases
│   │   ├── functions
│   │   ├── config
│   │   ├── paths
│   │   ├── history_config
│   │   ├── completions
│   │   └── completion_scripts/
│   ├── zsh/                     # Zsh configuration
│   │   ├── aliases
│   │   └── functions
│   └── config/                  # XDG config subdirectories
│       ├── nvim/
│       └── gh/
└── archive/                     # Old/unused configurations
    ├── oh-my-zsh/              # Old zsh setup
    ├── janus/                  # Old vim setup
    ├── vim.ignore/             # Old vim config
    └── vimrc.ignore            # Old vim config
```

## Benefits

### 1. Crystal Clear Separation
- **Root level**: Project management only
- **dotfiles/**: Everything that gets symlinked
- **archive/**: Old configs (preserved but not active)

### 2. Simplified install.sh
```bash
# Clean and simple - no ignore logic needed!
for file in home/*; do
  filename=$(basename "$file")
  link_file "home/$filename" "$filename"
done
```

### 3. Easy Maintenance
- ✅ Add new dotfile? Just put it in `home/`
- ✅ No more growing ignore list
- ✅ Clear what's active vs archived
- ✅ Easy to understand structure

### 4. Better Git History
- ✅ Separate commits for project vs config changes
- ✅ Cleaner diffs
- ✅ Easier to track what changed

## Migration Tasks

### Task 0.1: Create New Structure
- [x] Create `home/` directory
- [x] Create `archive/` directory
- [x] Plan file movements

### Task 0.2: Move Active Dotfiles
- [x] Move all current dotfiles to `home/` subdirectory
- [x] Preserve directory structure (bash/, zsh/, config/)
- [x] Update any internal path references

### Task 0.3: Archive Old Configurations
- [x] Move `oh-my-zsh/` to `archive/oh-my-zsh/`
- [x] Move `janus/` to `archive/janus/`
- [x] Move `vim.ignore/` to `archive/vim.ignore/`
- [x] Move `vimrc.ignore` to `archive/vimrc.ignore`

### Task 0.4: Update install.sh
- [x] Simplify installation logic
- [x] Remove complex ignore list
- [x] Update paths to use `home/` subdirectory
- [x] Add config/ subdirectory handling

### Task 0.5: Update Documentation
- [x] Update README.md with new structure
- [x] Document migration process
- [x] Update any references to old paths

### Task 0.6: Test and Verify
- [x] Backup current symlinks
- [x] Test new installation process
- [x] Verify all dotfiles link correctly
- [x] Test that archived files are ignored

## Migration Script Outline

```bash
#!/bin/bash
# migrate-structure.sh

# 1. Backup current state
cp -r ~/.dotfiles ~/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)

# 2. Create new directories
mkdir -p ~/.dotfiles/home
mkdir -p ~/.dotfiles/archive

# 3. Move active dotfiles
mv ~/.dotfiles/bash_profile ~/.dotfiles/home/
mv ~/.dotfiles/gitconfig ~/.dotfiles/home/
# ... etc for all active dotfiles

# 4. Move directories
mv ~/.dotfiles/bash ~/.dotfiles/home/
mv ~/.dotfiles/zsh ~/.dotfiles/home/

# 5. Archive old configs
mv ~/.dotfiles/oh-my-zsh ~/.dotfiles/archive/
mv ~/.dotfiles/janus ~/.dotfiles/archive/
mv ~/.dotfiles/vim.ignore ~/.dotfiles/archive/

# 6. Update install.sh
# (manual step)

# 7. Test new structure
cd ~/.dotfiles
./install.sh
```

## Risks and Mitigations

### Risk: Breaking Current Symlinks
- **Mitigation**: Comprehensive backup before migration
- **Mitigation**: Test new install.sh thoroughly
- **Mitigation**: Keep old structure until verified

### Risk: Missing Files in Migration
- **Mitigation**: Detailed inventory of current files
- **Mitigation**: Systematic migration checklist
- **Mitigation**: Verification step after migration

### Risk: Path References in Configs
- **Mitigation**: Search for hardcoded paths in configs
- **Mitigation**: Update any references to old structure
- **Mitigation**: Test all functionality after migration

## Success Criteria
- [ ] Clean separation: project files vs dotfiles
- [ ] Simplified install.sh with no ignore list
- [ ] All current dotfiles work identically
- [ ] Old configs preserved in archive/
- [ ] Easy to add new dotfiles in future

## Dependencies
- This should be done BEFORE Tasks 000-002 (config management, bash modernization, zsh setup)
- This restructuring will make those tasks cleaner and easier

## Estimated Time
- 2-3 hours for complete restructuring and testing
- Worth the investment for long-term maintainability
