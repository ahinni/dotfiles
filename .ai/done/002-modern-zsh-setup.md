# Task 002: Modern Zsh Setup

## Overview
Create a modern, performant zsh configuration that leverages the cleaned bash configuration from Task 001. Replace the outdated Oh-My-Zsh setup with modern alternatives and zsh-specific enhancements.

## Prerequisites
- Task 001 (Modernize Bash Configuration) must be completed
- Clean, modular bash configuration available for porting

## Current Zsh Issues

### 1. Outdated Oh-My-Zsh Setup
- **Local copy**: Using bundled oh-my-zsh instead of proper installation
- **Old version**: Likely several years out of date
- **Hardcoded paths**: `ZSH=$HOME/.dotfiles/oh-my-zsh`
- **Commented out**: Most oh-my-zsh functionality is disabled

### 2. zshrc Configuration Issues
- **Hardcoded user path**: `/Users/ben/.rvm/scripts/rvm` (wrong user)
- **Disabled features**: NVM, oh-my-zsh sourcing, custom files all commented
- **Old Ruby tuning**: Performance settings no longer relevant
- **Mixed PATH**: Duplicated and conflicting PATH management

### 3. Outdated zsh Files
- **home/zsh/aliases**: Outdated, points to old projects
- **home/zsh/functions**: Subset of bash functions, missing recent additions
- **Missing modern zsh features**: No syntax highlighting, autosuggestions, etc.

## Modern Zsh Approach

### Replace Oh-My-Zsh with Modern Stack
1. **Starship Prompt**: Fast, customizable, cross-shell prompt
2. **Zinit Plugin Manager**: Fast, feature-rich plugin management
3. **Essential Plugins**:
   - `zsh-autosuggestions`: Fish-like autosuggestions
   - `zsh-syntax-highlighting`: Syntax highlighting
   - `zsh-completions`: Additional completions
   - `fzf`: Fuzzy finder integration

## Tasks

### Task 2.1: Remove Old Oh-My-Zsh Setup
- [ ] Remove `oh-my-zsh` directory from dotfiles
- [ ] Clean up old zshrc references
- [ ] Remove old zsh theme configurations
- [ ] Update install.sh to skip oh-my-zsh directory

### Task 2.2: Install Modern Tools
- [ ] Install Starship prompt: `brew install starship`
- [ ] Install fzf: `brew install fzf`
- [ ] Install zinit (plugin manager)
- [ ] Configure Starship with custom config

### Task 2.3: Create Modern home/zshrc
- [ ] Create clean, modular zshrc structure
- [ ] Set up zinit plugin management
- [ ] Configure essential plugins
- [ ] Port cleaned bash configurations
- [ ] Add zsh-specific optimizations

### Task 2.4: Port and Enhance Configurations
- [ ] Port cleaned home/bash/aliases to home/zsh/aliases
- [ ] Port cleaned home/bash/functions to home/zsh/functions
- [ ] Add zsh-specific completions
- [ ] Configure zsh history settings
- [ ] Set up zsh options for better UX

### Task 2.5: Create Zsh-Specific Enhancements
- [ ] Configure advanced tab completion
- [ ] Set up directory navigation improvements
- [ ] Add git integration enhancements
- [ ] Configure fzf integration
- [ ] Set up command history search

### Task 2.6: Performance Optimization
- [ ] Lazy load heavy tools (NVM, RVM)
- [ ] Optimize plugin loading order
- [ ] Profile startup time
- [ ] Add async loading where possible

## Proposed File Structure

```
home/
├── zshrc                # Main zsh configuration
└── zsh/
    ├── aliases              # Ported and enhanced aliases
    ├── functions            # Ported and enhanced functions
    ├── completions          # Zsh-specific completions
    ├── config               # Zsh options and settings
    ├── plugins              # Plugin configurations
    └── starship.toml        # Starship prompt configuration
```

## Modern home/zshrc Structure

```bash
# Performance: Start timing
# zmodload zsh/zprof

# Zinit installation and setup
# Plugin loading with zinit
# Zsh options and settings
# Source modular configurations
# Tool initialization (lazy loaded)
# Starship prompt initialization

# Performance: End timing
# zprof
```

## Key Features to Implement

### 1. Smart Completions
- Context-aware git completions
- Docker/kubectl completions
- npm/yarn completions
- Custom project completions

### 2. Enhanced Navigation
- Auto-cd to directories
- Smart directory stack
- Fuzzy directory search
- Recent directory jumping

### 3. Git Integration
- Enhanced git status in prompt
- Git aliases with better feedback
- Interactive git operations
- Branch management helpers

### 4. Development Workflow
- Project-specific environment loading
- Smart tool version management
- Enhanced history search
- Command suggestion system

## Migration Strategy

### Phase 1: Parallel Setup
- Keep existing bash config working
- Set up zsh alongside bash
- Test zsh configuration thoroughly
- Gradually migrate daily workflow

### Phase 2: Feature Parity
- Ensure all bash aliases/functions work in zsh
- Add zsh-specific improvements
- Test all development workflows
- Performance tune the setup

### Phase 3: Full Migration
- Switch default shell to zsh
- Remove bash-specific configurations
- Clean up unused files
- Document new features

## Testing Plan

### Functionality Tests
- [ ] All aliases work correctly
- [ ] All functions execute properly
- [ ] Git workflows function as expected
- [ ] Development tools load correctly
- [ ] Completions work for all tools

### Performance Tests
- [ ] Shell startup time < 1 second
- [ ] Plugin loading doesn't block
- [ ] Command execution responsive
- [ ] Memory usage reasonable

### Integration Tests
- [ ] iTerm2 integration works
- [ ] tmux compatibility verified
- [ ] SSH sessions work properly
- [ ] All development environments function

## Expected Benefits

### Performance Improvements
- Faster shell startup (lazy loading)
- Better plugin management
- Optimized completion system
- Reduced memory usage

### User Experience Enhancements
- Better autocompletion
- Syntax highlighting
- Command suggestions
- Enhanced navigation
- Improved git integration

### Maintenance Benefits
- Modern, actively maintained tools
- Modular configuration
- Easy customization
- Better documentation

## Dependencies
- Task 001 completion
- Homebrew installed
- Modern terminal (iTerm2 recommended)

## Estimated Time
- 3-4 hours for complete setup
- Additional time for customization and tuning

## Notes
- Keep bash config as fallback during transition
- Document all custom configurations
- Consider user's preference for manual testing over automated testing
- Maintain compatibility with existing workflows
