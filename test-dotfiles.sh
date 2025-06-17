#!/bin/bash

# Script to test dotfiles installation in Docker

set -e

echo "🐳 Building Docker test environment..."
docker build -f Dockerfile.test -t dotfiles-test .

echo ""
echo "🧪 Starting interactive dotfiles test container..."
echo ""
echo "📋 Testing Guide:"
echo "  1. Check initial state:     ls -la ~/"
echo "  2. Run installation:       ./install.sh"
echo "  3. Check results:          ls -la ~/"
echo "  4. Test specific configs:  cat ~/.bashrc"
echo "  5. Verify symlinks:        readlink ~/.gitconfig"
echo ""
echo "💡 Tips:"
echo "  - Try different install options (y/n/a/q)"
echo "  - Check that symlinks point to /home/testuser/dotfiles/"
echo "  - Test with existing files by running install twice"
echo ""
echo "🚪 To exit the container, type 'exit'"
echo ""

# Run the container interactively
docker run -it --rm dotfiles-test
