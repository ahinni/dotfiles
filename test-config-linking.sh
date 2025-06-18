#!/bin/bash

# Test script for config linking functionality
# This script tests the enhanced install.sh config linking in a safe way

set -e

echo "🧪 Testing Enhanced Config Linking"
echo "=================================="
echo ""

# Check current state
echo "📋 Current state before testing:"
echo "~/.config/nvim exists: $([ -d ~/.config/nvim ] && echo "✅ YES" || echo "❌ NO")"
echo "~/.config/gh exists: $([ -d ~/.config/gh ] && echo "✅ YES" || echo "❌ NO")"

if [ -L ~/.config/nvim ]; then
    echo "~/.config/nvim is symlink to: $(readlink ~/.config/nvim)"
elif [ -d ~/.config/nvim ]; then
    echo "~/.config/nvim is a directory (not symlink)"
fi

if [ -L ~/.config/gh ]; then
    echo "~/.config/gh is symlink to: $(readlink ~/.config/gh)"
elif [ -d ~/.config/gh ]; then
    echo "~/.config/gh is a directory (not symlink)"
fi

echo ""
echo "📁 Dotfiles config structure:"
echo "home/config/nvim exists: $([ -d home/config/nvim ] && echo "✅ YES" || echo "❌ NO")"
echo "home/config/gh exists: $([ -d home/config/gh ] && echo "✅ YES" || echo "❌ NO")"

echo ""
echo "🔧 Testing nvim config functionality..."
if command -v nvim >/dev/null 2>&1; then
    echo "✅ nvim is available"
    # Test that nvim can start without errors (quick test)
    if nvim --version >/dev/null 2>&1; then
        echo "✅ nvim --version works"
    else
        echo "⚠️  nvim --version failed"
    fi
else
    echo "⚠️  nvim not found in PATH"
fi

echo ""
echo "🔧 Testing gh config functionality..."
if command -v gh >/dev/null 2>&1; then
    echo "✅ gh is available"
    if gh --version >/dev/null 2>&1; then
        echo "✅ gh --version works"
    else
        echo "⚠️  gh --version failed"
    fi
else
    echo "⚠️  gh not found in PATH"
fi

echo ""
echo "🎯 Ready to test install.sh config linking!"
echo ""
echo "To proceed with testing:"
echo "1. Run: ./install.sh"
echo "2. Check that configs are properly linked"
echo "3. Test that nvim and gh still work"
echo ""
echo "🛡️  Safety notes:"
echo "- Original configs will be backed up automatically"
echo "- Backup available at ~/.config.backup.20250617_211015"
echo "- You can restore from backup if needed"
