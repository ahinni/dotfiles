#!/bin/bash

# Sync VS Code keybindings across platforms
# On Linux: Merges default macOS keybindings with custom keybindings
# Detects local modifications and prompts to merge them into source control

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
CUSTOM_KEYBINDINGS="$DOTFILES_DIR/vscode/keybindings.json"
DEFAULTS_KEYBINDINGS="$DOTFILES_DIR/vscode/defaults/macos.keybindings.json"
LINUX_KEYBINDINGS="$DOTFILES_DIR/vscode/keybindings-linux.json"
VSCODE_KEYBINDINGS_LINK="$HOME/.config/Code/User/keybindings.json"

# Platform detection
if [[ "$OSTYPE" == "darwin"* ]]; then
    VSCODE_KEYBINDINGS="$HOME/Library/Application Support/Code/User/keybindings.json"
else
    VSCODE_KEYBINDINGS="$HOME/.config/Code/User/keybindings.json"
fi

# Helper function to strip comments from JSON-with-comments files
# Removes lines starting with // and handles inline comments
strip_json_comments() {
    local file=$1
    sed -E '
        /^[[:space:]]*\/\//d
        s/[[:space:]]*\/\/.*$//
    ' "$file"
}

# Helper function to merge defaults with custom keybindings
# Creates a single JSON array with defaults, then custom keybindings separated by a comment
merge_keybindings_files() {
    local defaults=$1
    local custom=$2
    local output=$3

    local temp_file=$(mktemp)
    local temp_with_comments=$(mktemp)

    # Start with opening bracket
    echo "[" > "$temp_with_comments"

    # Add defaults (strip comments, remove outer brackets and blank lines)
    strip_json_comments "$defaults" | sed '/^[[:space:]]*$/d' | sed '1d;$d' >> "$temp_with_comments"

    # Add separator comment
    echo "  // ============================================" >> "$temp_with_comments"
    echo "  // Custom keybindings from vscode/keybindings.json" >> "$temp_with_comments"
    echo "  // ============================================" >> "$temp_with_comments"

    # Add custom keybindings (strip comments and remove outer brackets)
    if [ -s "$custom" ]; then
        local custom_count=$(strip_json_comments "$custom" | jq 'length' 2>/dev/null || echo 0)
        if [ "$custom_count" -gt 0 ]; then
            echo "," >> "$temp_with_comments"
            strip_json_comments "$custom" | sed '1d;$d' >> "$temp_with_comments"
        fi
    fi

    # Close the array
    echo "]" >> "$temp_with_comments"

    # Strip comments from the file to validate JSON
    strip_json_comments "$temp_with_comments" > "$temp_file"

    # Validate the JSON
    if ! jq empty "$temp_file" 2>/dev/null; then
        echo "❌ Failed to create valid JSON during merge"
        rm "$temp_file" "$temp_with_comments"
        return 1
    fi

    # Write the version with comments to output
    cp "$temp_with_comments" "$output"
    rm "$temp_file" "$temp_with_comments"
    return 0
}

# Check for newer versions of the defaults submodule
check_submodule_updates() {
    # Check if submodule exists (either .git dir or .git file for submodules)
    if [ ! -e "$DOTFILES_DIR/vscode/defaults/.git" ]; then
        return 0
    fi

    echo "🔍 Checking for VS Code defaults updates..."
    cd "$DOTFILES_DIR/vscode/defaults"

    # Get current branch (usually master or main)
    local current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    # Fetch latest from remote
    git fetch origin "$current_branch" 2>/dev/null || git fetch origin 2>/dev/null

    # Compare local vs remote
    local local_commit=$(git rev-parse HEAD 2>/dev/null)
    local remote_commit=$(git rev-parse "origin/$current_branch" 2>/dev/null)

    if [ -z "$remote_commit" ]; then
        # Fallback: try to get any remote tracking branch
        remote_commit=$(git rev-parse "origin/HEAD" 2>/dev/null | cut -d' ' -f1)
    fi

    if [ "$local_commit" != "$remote_commit" ] && [ -n "$remote_commit" ]; then
        echo "⚠️  Newer VS Code defaults are available!"
        echo "   Current: ${local_commit:0:7}"
        echo "   Latest:  ${remote_commit:0:7}"
        echo ""
        echo "   To update, run:"
        echo "   git submodule update --remote vscode/defaults"
        echo ""
    elif [ -n "$remote_commit" ]; then
        echo "✅ VS Code defaults are up to date"
    fi

    cd "$DOTFILES_DIR"
}

# Main sync function
sync_keybindings() {
    echo "🔄 Syncing VS Code keybindings..."
    echo "Platform: $OSTYPE"
    echo ""

    # Verify source files exist
    if [ ! -f "$CUSTOM_KEYBINDINGS" ]; then
        echo "❌ Custom keybindings not found: $CUSTOM_KEYBINDINGS"
        exit 1
    fi

    if [ ! -f "$DEFAULTS_KEYBINDINGS" ]; then
        echo "❌ Default keybindings not found: $DEFAULTS_KEYBINDINGS"
        echo "   Make sure the submodule is initialized: git submodule update --init"
        exit 1
    fi

    # On macOS, just verify the symlink
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "📍 macOS detected - keybindings should be symlinked"
        if [ -L "$VSCODE_KEYBINDINGS" ]; then
            local target=$(readlink "$VSCODE_KEYBINDINGS")
            if [ "$target" = "$CUSTOM_KEYBINDINGS" ]; then
                echo "✅ Keybindings correctly symlinked to $CUSTOM_KEYBINDINGS"
            else
                echo "⚠️  Keybindings symlinked to: $target"
                echo "   Expected: $CUSTOM_KEYBINDINGS"
            fi
        else
            echo "⚠️  Keybindings not symlinked. Run install.sh to set up."
        fi
        echo ""
        check_submodule_updates
        return 0
    fi

    # Linux: Merge defaults with custom
    echo "🐧 Linux detected - merging keybindings..."

    # Merge defaults with custom and write to the generated Linux keybindings file
    echo "🔗 Merging defaults with custom keybindings..."

    if ! merge_keybindings_files "$DEFAULTS_KEYBINDINGS" "$CUSTOM_KEYBINDINGS" "$LINUX_KEYBINDINGS"; then
        exit 1
    fi

    echo "✅ Generated $LINUX_KEYBINDINGS"
    echo ""
    echo "📊 Summary:"
    local defaults_count=$(strip_json_comments "$DEFAULTS_KEYBINDINGS" | jq 'length')
    local custom_count=$(jq 'length' "$CUSTOM_KEYBINDINGS")
    local final_count=$(strip_json_comments "$LINUX_KEYBINDINGS" | jq 'length')
    echo "   Defaults: $defaults_count keybindings"
    echo "   Custom: $custom_count keybindings"
    echo "   Final: $final_count keybindings"
    echo ""

    # Create symlink from ~/.config/Code/User/keybindings.json to the generated file
    echo "🔗 Setting up symlink..."
    local config_dir=$(dirname "$VSCODE_KEYBINDINGS_LINK")

    # Create .config/Code/User if it doesn't exist
    if [ ! -d "$config_dir" ]; then
        echo "📁 Creating $config_dir"
        mkdir -p "$config_dir"
    fi

    # Handle existing file/symlink
    if [ -L "$VSCODE_KEYBINDINGS_LINK" ]; then
        # It's a symlink, check if it points to the right place
        local current_target=$(readlink "$VSCODE_KEYBINDINGS_LINK")
        if [ "$current_target" = "$LINUX_KEYBINDINGS" ]; then
            echo "✅ Symlink already correct: $VSCODE_KEYBINDINGS_LINK -> $LINUX_KEYBINDINGS"
        else
            echo "⚠️  Symlink points to wrong location: $current_target"
            echo "   Updating to: $LINUX_KEYBINDINGS"
            rm "$VSCODE_KEYBINDINGS_LINK"
            ln -s "$LINUX_KEYBINDINGS" "$VSCODE_KEYBINDINGS_LINK"
            echo "✅ Symlink updated"
        fi
    elif [ -f "$VSCODE_KEYBINDINGS_LINK" ]; then
        # It's a regular file, back it up and create symlink
        echo "⚠️  Found existing keybindings.json file (not a symlink)"
        local backup_file="$VSCODE_KEYBINDINGS_LINK.backup.$(date +%s)"
        echo "   Backing up to: $backup_file"
        mv "$VSCODE_KEYBINDINGS_LINK" "$backup_file"
        ln -s "$LINUX_KEYBINDINGS" "$VSCODE_KEYBINDINGS_LINK"
        echo "✅ Created symlink: $VSCODE_KEYBINDINGS_LINK -> $LINUX_KEYBINDINGS"
    else
        # File doesn't exist, create symlink
        ln -s "$LINUX_KEYBINDINGS" "$VSCODE_KEYBINDINGS_LINK"
        echo "✅ Created symlink: $VSCODE_KEYBINDINGS_LINK -> $LINUX_KEYBINDINGS"
    fi
    echo ""

    # Check for updates to the defaults submodule
    check_submodule_updates
}

# Run sync
sync_keybindings

