#!/bin/bash

# Migration script for dotfiles restructure
# Safely switches from old structure to new home/ structure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the absolute path of the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles-migration-backup-$(date +%Y%m%d_%H%M%S)"
SYMLINK_BACKUP="$BACKUP_DIR/symlinks.txt"

echo -e "${BLUE}🔄 Dotfiles Migration Script${NC}"
echo -e "${BLUE}=============================${NC}"
echo ""
echo "This script will migrate your dotfiles to the new home/ structure."
echo "Current dotfiles directory: $DOTFILES_DIR"
echo "Backup will be created at: $BACKUP_DIR"
echo ""

# Function to log messages
log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] ERROR: $1${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if home/ directory exists
    if [[ ! -d "$DOTFILES_DIR/home" ]]; then
        error "home/ directory not found in $DOTFILES_DIR"
        error "Please ensure you've completed steps 1-2 (backup and copy files to home/)"
        exit 1
    fi
    
    # Check if updated install.sh exists
    if ! grep -q "home/\*" "$DOTFILES_DIR/install.sh"; then
        error "install.sh doesn't appear to be updated for home/ structure"
        error "Please ensure install.sh has been updated for the new structure"
        exit 1
    fi
    
    log "Prerequisites check passed ✓"
}

# Function to create backup
create_backup() {
    log "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    # Backup current symlinks
    log "Backing up current symlink information..."
    find ~ -maxdepth 1 -type l -exec ls -la {} \; | grep dotfiles > "$SYMLINK_BACKUP" || true
    
    if [[ -s "$SYMLINK_BACKUP" ]]; then
        log "Found $(wc -l < "$SYMLINK_BACKUP") existing dotfiles symlinks"
        echo "Symlinks backed up to: $SYMLINK_BACKUP"
    else
        warn "No existing dotfiles symlinks found"
    fi
}

# Function to show current symlinks
show_current_symlinks() {
    echo ""
    echo -e "${BLUE}Current dotfiles symlinks:${NC}"
    if [[ -s "$SYMLINK_BACKUP" ]]; then
        cat "$SYMLINK_BACKUP"
    else
        echo "No dotfiles symlinks found"
    fi
    echo ""
}

# Function to remove old symlinks
remove_old_symlinks() {
    log "Removing old symlinks..."
    
    if [[ -s "$SYMLINK_BACKUP" ]]; then
        # Extract just the symlink paths and remove them
        awk '{print $9}' "$SYMLINK_BACKUP" | while read -r symlink; do
            if [[ -L "$symlink" ]]; then
                log "Removing symlink: $symlink"
                rm "$symlink"
            fi
        done
        log "Old symlinks removed ✓"
    else
        log "No old symlinks to remove"
    fi
}

# Function to install new structure
install_new_structure() {
    log "Installing new dotfiles structure..."
    
    cd "$DOTFILES_DIR"
    
    # Run the new install script
    if ./install.sh; then
        log "New structure installed successfully ✓"
    else
        error "Installation failed!"
        return 1
    fi
}

# Function to verify installation
verify_installation() {
    log "Verifying installation..."
    
    local errors=0
    
    # Check that symlinks point to home/ directory
    find ~ -maxdepth 1 -type l -exec ls -la {} \; | grep dotfiles | while read -r line; do
        local symlink=$(echo "$line" | awk '{print $9}')
        local target=$(echo "$line" | awk '{print $11}')
        
        if [[ "$target" == *"/home/"* ]]; then
            log "✓ $symlink -> $target"
        else
            warn "✗ $symlink -> $target (not pointing to home/ structure)"
            ((errors++))
        fi
    done
    
    # Test basic functionality
    log "Testing basic functionality..."
    
    # Test git config
    if git config user.name >/dev/null 2>&1; then
        log "✓ Git configuration working"
    else
        warn "✗ Git configuration may have issues"
        ((errors++))
    fi
    
    # Test bash config
    if [[ -f ~/.bash_profile ]] && [[ -L ~/.bash_profile ]]; then
        log "✓ Bash profile linked"
    else
        warn "✗ Bash profile not properly linked"
        ((errors++))
    fi
    
    return $errors
}

# Function to rollback if needed
rollback() {
    error "Rolling back changes..."
    
    # Remove new symlinks
    find ~ -maxdepth 1 -type l -exec ls -la {} \; | grep dotfiles | awk '{print $9}' | xargs rm -f
    
    # Restore old symlinks if backup exists
    if [[ -s "$SYMLINK_BACKUP" ]]; then
        log "Restoring old symlinks..."
        while IFS= read -r line; do
            local symlink=$(echo "$line" | awk '{print $9}')
            local target=$(echo "$line" | awk '{print $11}')
            
            if [[ -n "$symlink" ]] && [[ -n "$target" ]]; then
                log "Restoring: $symlink -> $target"
                ln -sf "$target" "$symlink"
            fi
        done < "$SYMLINK_BACKUP"
    fi
    
    error "Rollback completed. Your original setup should be restored."
}

# Main migration function
main() {
    check_prerequisites
    create_backup
    show_current_symlinks
    
    echo -e "${YELLOW}Ready to proceed with migration?${NC}"
    echo "This will:"
    echo "  1. Remove current dotfiles symlinks"
    echo "  2. Install new home/ structure symlinks"
    echo "  3. Verify everything works"
    echo ""
    echo -n "Continue? [y/N] "
    read -r answer
    
    if [[ "$answer" != "y" ]] && [[ "$answer" != "Y" ]]; then
        echo "Migration cancelled."
        exit 0
    fi
    
    echo ""
    log "Starting migration..."
    
    # Perform migration
    if remove_old_symlinks && install_new_structure; then
        if verify_installation; then
            log "Migration completed successfully! 🎉"
            echo ""
            echo -e "${GREEN}✓ All dotfiles are now using the new home/ structure${NC}"
            echo -e "${GREEN}✓ Backup created at: $BACKUP_DIR${NC}"
            echo ""
            echo "Next steps:"
            echo "  1. Test your shell, git, vim, and other tools"
            echo "  2. If everything works, you can clean up old files"
            echo "  3. Move archived configs (oh-my-zsh, janus, etc.) to archive/"
        else
            warn "Migration completed but verification found issues"
            echo ""
            echo "Please check the warnings above and test your configuration."
            echo "If there are problems, you can rollback using the backup at:"
            echo "$BACKUP_DIR"
        fi
    else
        error "Migration failed!"
        rollback
        exit 1
    fi
}

# Handle Ctrl+C gracefully
trap 'echo ""; error "Migration interrupted!"; rollback; exit 1' INT

# Run main function
main
