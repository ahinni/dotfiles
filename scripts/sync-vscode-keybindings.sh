#!/bin/bash

# Sync VS Code keybindings across platforms
# On Linux: Merges default macOS keybindings with custom keybindings
# Detects local modifications and prompts to merge them into source control

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
CUSTOM_KEYBINDINGS="$DOTFILES_DIR/vscode/keybindings.json"
DEFAULTS_KEYBINDINGS="$DOTFILES_DIR/vscode/defaults/macos.keybindings.json"

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

# Helper function to extract keybinding keys from JSON
# Returns a sorted list of "key" values
extract_keys() {
    local file=$1
    strip_json_comments "$file" | jq -r '.[] | .key' 2>/dev/null | sort || echo ""
}

# Helper function to merge JSON arrays, with later entries overriding earlier ones
# Usage: merge_json_arrays defaults.json custom.json output.json
merge_json_arrays() {
    local defaults=$1
    local custom=$2
    local output=$3

    # Use jq to merge: start with defaults, then add custom (which override by key)
    # Strip comments from both files before merging
    jq -s '
        (.[0] | map({key: .key, value: .})) as $defaults |
        (.[1] | map({key: .key, value: .})) as $custom |
        ($defaults | map(.key) + ($custom | map(.key)) | unique) as $all_keys |
        [
            $all_keys[] as $k |
            (
                ($custom | map(select(.key == $k)) | .[0].value) //
                ($defaults | map(select(.key == $k)) | .[0].value)
            )
        ]
    ' <(strip_json_comments "$defaults") <(strip_json_comments "$custom") > "$output"
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

    # Create .config/Code/User if it doesn't exist
    local config_dir=$(dirname "$VSCODE_KEYBINDINGS")
    if [ ! -d "$config_dir" ]; then
        echo "📁 Creating $config_dir"
        mkdir -p "$config_dir"
    fi

    # Check for local modifications
    if [ -f "$VSCODE_KEYBINDINGS" ]; then
        echo ""
        echo "🔍 Checking for local modifications..."

        # Extract keys from all three sources
        local custom_keys=$(extract_keys "$CUSTOM_KEYBINDINGS")
        local current_keys=$(extract_keys "$VSCODE_KEYBINDINGS")

        # Find keys in current that aren't in custom (local modifications)
        local local_mods=$(comm -23 <(echo "$current_keys") <(echo "$custom_keys"))

        if [ -n "$local_mods" ]; then
            echo "⚠️  Found local keybindings not in source control:"
            echo "$local_mods" | sed 's/^/   - /'
            echo ""

            # Prompt user
            read -p "Merge these into vscode/keybindings.json? (y/n) " -n 1 -r
            echo ""

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "📝 Merging local modifications into $CUSTOM_KEYBINDINGS"

                # Create a temporary merged file with local mods
                local temp_merged=$(mktemp)
                jq -s '
                    (.[0] | map({key: .key, value: .})) as $custom |
                    (.[1] | map({key: .key, value: .})) as $current |
                    ($custom | map(.key) + ($current | map(.key)) | unique) as $all_keys |
                    [
                        $all_keys[] as $k |
                        (
                            ($current | map(select(.key == $k)) | .[0].value) //
                            ($custom | map(select(.key == $k)) | .[0].value)
                        )
                    ]
                ' "$CUSTOM_KEYBINDINGS" "$VSCODE_KEYBINDINGS" > "$temp_merged"

                # Update the custom keybindings file
                cp "$temp_merged" "$CUSTOM_KEYBINDINGS"
                rm "$temp_merged"

                echo "✅ Updated $CUSTOM_KEYBINDINGS"
                echo "   Review with: git diff vscode/keybindings.json"
            else
                echo "⏭️  Skipping merge. Local modifications will be overwritten."
            fi
            echo ""
        else
            echo "✅ No local modifications found"
        fi
    fi

    # Merge defaults with custom and write to VS Code config
    echo "🔗 Merging defaults with custom keybindings..."
    local temp_merged=$(mktemp)
    merge_json_arrays "$DEFAULTS_KEYBINDINGS" "$CUSTOM_KEYBINDINGS" "$temp_merged"

    # Validate the merged JSON
    if ! jq empty "$temp_merged" 2>/dev/null; then
        echo "❌ Failed to create valid JSON"
        rm "$temp_merged"
        exit 1
    fi

    # Write to VS Code config
    cp "$temp_merged" "$VSCODE_KEYBINDINGS"
    rm "$temp_merged"

    echo "✅ Keybindings synced to $VSCODE_KEYBINDINGS"
    echo ""
    echo "📊 Summary:"
    echo "   Defaults: $(jq 'length' "$DEFAULTS_KEYBINDINGS") keybindings"
    echo "   Custom: $(jq 'length' "$CUSTOM_KEYBINDINGS") keybindings"
    echo "   Final: $(jq 'length' "$VSCODE_KEYBINDINGS") keybindings"
    echo ""

    # Check for updates to the defaults submodule
    check_submodule_updates
}

# Run sync
sync_keybindings

