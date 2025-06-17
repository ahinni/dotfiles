# Task 001: Modernize Bash Configuration

## Overview
Clean up and modernize the existing bash configuration to remove outdated elements, consolidate duplicates, and establish a solid foundation for either continued bash use or future zsh migration.

## Current Issues Identified

### 1. bash_profile Issues
- **Outdated paths**: `/usr/local/opt/python@3.9/libexec/bin` (hardcoded Python version)
- **Duplicate bash completion**: Both old and new Homebrew paths
- **Mixed PATH management**: PATH modifications scattered across multiple files
- **Hardcoded user paths**: `/Users/aaron/.modular/bin`
- **Commented dead code**: Lines 26-28, 16

### 2. bash/aliases Issues
- **Duplicate entries**: Lines 50-67 duplicate earlier aliases
- **Outdated references**:
  - `bpr` points to old GitHub repo (`sotelsys/voiplink`)
  - Work directory aliases point to old projects
  - `ali` alias points to bash aliases but should be generic
- **Inconsistent editor**: Mix of `vim` and `nvim`
- **Dead aliases**: References to non-existent directories/projects

### 3. bash/functions Issues
- **Outdated package managers**: `sagi` (apt-get), `syi` (yum) not needed on macOS
- **Old git workflows**: `git-done` function assumes specific workflow
- **Complex functions**: Some functions could be simplified

### 4. bash/config Issues
- **SSH agent complexity**: Overly complex SSH agent management for modern systems
- **Hardcoded prompt**: Computer name retrieval could be simplified
- **Old screen integration**: PROMPT_COMMAND for screen (rarely used now)

### 5. bash/paths Issues
- **Hardcoded versions**: Ruby 3.0.0 path
- **Outdated paths**: MySQL man pages, old npm paths
- **Mixed with bash_profile**: PATH management split across files

## Tasks

### Task 1.1: Audit and Clean home/bash/aliases
- [ ] Remove duplicate aliases (lines 50-67)
- [ ] Update outdated repository references
- [ ] Standardize on single editor (nvim vs vim)
- [ ] Remove aliases pointing to non-existent directories
- [ ] Group related aliases together
- [ ] Add comments for alias groups

### Task 1.2: Modernize home/bash/functions
- [ ] Remove Linux package manager functions (`sagi`, `syi`)
- [ ] Simplify or remove complex git workflow functions
- [ ] Update `cdgem` function for modern gem management
- [ ] Review and test all Kubernetes functions
- [ ] Add error handling to functions
- [ ] Document complex functions

### Task 1.3: Consolidate PATH Management
- [ ] Create single `home/bash/paths` file with all PATH modifications
- [ ] Remove hardcoded version numbers
- [ ] Use dynamic path detection where possible
- [ ] Remove duplicate PATH entries from home/bash_profile
- [ ] Order paths by priority (local bins first)

### Task 1.4: Simplify home/bash_profile
- [ ] Remove duplicate bash completion loading
- [ ] Consolidate tool initialization (NVM, RVM, jenv)
- [ ] Remove commented dead code
- [ ] Add conditional loading for optional tools
- [ ] Improve error handling for missing tools

### Task 1.5: Modernize home/bash/config
- [ ] Simplify SSH agent management (use system keychain)
- [ ] Update prompt configuration
- [ ] Remove screen-specific configurations
- [ ] Add modern shell options
- [ ] Improve color configuration

### Task 1.6: Create home/bash/history_config
- [ ] Review current history configuration
- [ ] Add modern history options
- [ ] Ensure history is properly preserved
- [ ] Add history search improvements

## Expected Outcomes

### File Structure After Cleanup
```
home/
├── bash_profile     # Clean, minimal file that sources modular configs
└── bash/
    ├── aliases          # Clean, organized aliases
    ├── functions        # Modern, tested functions
    ├── config          # Shell options and prompt
    ├── paths           # Consolidated PATH management
    ├── history_config  # History configuration
    └── completions     # Completion scripts
```

### home/bash_profile After Cleanup
- Clean, minimal file that sources modular configs
- Conditional loading of optional tools
- No hardcoded paths or versions
- Proper error handling

### Benefits
1. **Easier maintenance**: Modular, well-organized configuration
2. **Better performance**: Remove unused/duplicate loading
3. **Cross-system compatibility**: Dynamic path detection
4. **Future-proof**: No hardcoded versions or paths
5. **Clean migration path**: Ready for zsh conversion

## Testing Plan
1. **Backup current config**: `cp -r ~/.dotfiles ~/.dotfiles.backup`
2. **Test in new shell**: Open new terminal after each change
3. **Verify aliases**: Test commonly used aliases
4. **Check functions**: Test git and kubernetes functions
5. **Validate paths**: Ensure all tools are accessible
6. **Performance test**: Check shell startup time

## Dependencies
- None (this is foundational work)

## Estimated Time
- 2-3 hours for complete modernization
- Can be done incrementally file by file

## Notes
- Keep a backup of original configuration
- Test each change in a new shell session
- Document any breaking changes
- Consider user's workflow preferences (remembered from previous interactions)
