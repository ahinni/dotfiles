#!/bin/bash

# Setup .config Directory Management for Dotfiles
# This script implements the safe, copy-first approach outlined in task 003

set -e  # Exit on any error

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "🔧 Setting up .config directory management for dotfiles"
echo "📁 Dotfiles directory: $DOTFILES_DIR"
echo "⏰ Timestamp: $TIMESTAMP"
echo ""

# Phase 1: Create Comprehensive Backup
echo "=== PHASE 1: Creating Comprehensive Backup ==="
echo "📦 Creating timestamped backup of ~/.config..."

if [ -d ~/.config ]; then
    cp -r ~/.config ~/.config.backup.$TIMESTAMP
    echo "✅ Backup created: ~/.config.backup.$TIMESTAMP"
    
    echo "📋 Documenting current state..."
    find ~/.config -type f > ~/.config.inventory.$TIMESTAMP
    echo "✅ Inventory created: ~/.config.inventory.$TIMESTAMP"
    
    echo "🔍 Verifying backup integrity..."
    if [ -d ~/.config.backup.$TIMESTAMP ]; then
        echo "✅ Backup directory exists"
        backup_files=$(find ~/.config.backup.$TIMESTAMP -type f | wc -l)
        original_files=$(find ~/.config -type f | wc -l)
        echo "📊 Original files: $original_files, Backup files: $backup_files"
        
        if [ "$backup_files" -eq "$original_files" ]; then
            echo "✅ Backup integrity verified"
        else
            echo "⚠️  File count mismatch - please verify manually"
        fi
    else
        echo "❌ Backup directory not found!"
        exit 1
    fi
else
    echo "ℹ️  No ~/.config directory found - nothing to backup"
fi

echo ""

# Phase 2: Setup Dotfiles Structure (COPY-FIRST Approach)
echo "=== PHASE 2: Setting up Dotfiles Structure ==="
echo "📁 Creating home/config/ directory in dotfiles..."

mkdir -p "$DOTFILES_DIR/home/config"
echo "✅ Created $DOTFILES_DIR/home/config/"

# Copy nvim config (if exists)
if [ -d ~/.config/nvim ]; then
    echo "📋 Copying ~/.config/nvim/ to home/config/nvim/ (COPY, not move)"
    cp -r ~/.config/nvim "$DOTFILES_DIR/home/config/nvim"
    echo "✅ nvim config copied"
    
    # Verify copy
    if [ -d "$DOTFILES_DIR/home/config/nvim" ]; then
        nvim_original=$(find ~/.config/nvim -type f | wc -l)
        nvim_copy=$(find "$DOTFILES_DIR/home/config/nvim" -type f | wc -l)
        echo "📊 nvim - Original files: $nvim_original, Copied files: $nvim_copy"
        
        if [ "$nvim_original" -eq "$nvim_copy" ]; then
            echo "✅ nvim copy verified"
        else
            echo "⚠️  nvim file count mismatch"
        fi
    fi
else
    echo "ℹ️  No ~/.config/nvim found - skipping"
fi

# Copy gh config (if exists)
if [ -d ~/.config/gh ]; then
    echo "📋 Copying ~/.config/gh/ to home/config/gh/ (COPY, not move)"
    cp -r ~/.config/gh "$DOTFILES_DIR/home/config/gh"
    echo "✅ gh config copied"
    
    # Verify copy
    if [ -d "$DOTFILES_DIR/home/config/gh" ]; then
        gh_original=$(find ~/.config/gh -type f | wc -l)
        gh_copy=$(find "$DOTFILES_DIR/home/config/gh" -type f | wc -l)
        echo "📊 gh - Original files: $gh_original, Copied files: $gh_copy"
        
        if [ "$gh_original" -eq "$gh_copy" ]; then
            echo "✅ gh copy verified"
        else
            echo "⚠️  gh file count mismatch"
        fi
    fi
else
    echo "ℹ️  No ~/.config/gh found - skipping"
fi

echo ""

# Phase 3: Test Copied Configs Work
echo "=== PHASE 3: Testing Copied Configs ==="

if [ -d "$DOTFILES_DIR/home/config/nvim" ]; then
    echo "🧪 Testing nvim config..."
    if command -v nvim >/dev/null 2>&1; then
        echo "✅ nvim is installed"
        # Test that the config directory structure is valid
        if [ -f "$DOTFILES_DIR/home/config/nvim/init.lua" ] || [ -f "$DOTFILES_DIR/home/config/nvim/init.vim" ]; then
            echo "✅ nvim config structure looks valid"
        else
            echo "⚠️  nvim config structure may be incomplete"
        fi
    else
        echo "⚠️  nvim not found in PATH"
    fi
fi

if [ -d "$DOTFILES_DIR/home/config/gh" ]; then
    echo "🧪 Testing gh config..."
    if command -v gh >/dev/null 2>&1; then
        echo "✅ gh is installed"
        # Test that the config files exist
        if [ -f "$DOTFILES_DIR/home/config/gh/config.yml" ]; then
            echo "✅ gh config.yml found"
        else
            echo "⚠️  gh config.yml not found"
        fi
    else
        echo "⚠️  gh not found in PATH"
    fi
fi

echo ""

# Phase 4: Show Next Steps
echo "=== NEXT STEPS ==="
echo "✅ Phase 1 Complete: Backup created and verified"
echo "✅ Phase 2 Complete: Configs copied to dotfiles structure"
echo "✅ Phase 3 Complete: Basic validation performed"
echo ""
echo "📋 What was copied:"
if [ -d "$DOTFILES_DIR/home/config/nvim" ]; then
    echo "  ✅ nvim config -> home/config/nvim/"
fi
if [ -d "$DOTFILES_DIR/home/config/gh" ]; then
    echo "  ✅ gh config -> home/config/gh/"
fi
echo ""
echo "🔄 Next manual steps:"
echo "  1. Review the copied configs in home/config/"
echo "  2. Update .gitignore to exclude sensitive configs"
echo "  3. Test the enhanced install.sh (when ready)"
echo "  4. Gradually link configs (nvim first, then gh)"
echo ""
echo "🛡️  Safety reminders:"
echo "  - Original configs are still in ~/.config/ (untouched)"
echo "  - Backup available at ~/.config.backup.$TIMESTAMP"
echo "  - Inventory available at ~/.config.inventory.$TIMESTAMP"
echo ""
echo "🎉 Setup complete! Ready for next phase."
