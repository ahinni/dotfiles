#!/bin/bash

# Get the absolute path of the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to link a file from home/ directory
link_file() {
  local source_path=$1
  local filename=$2
  echo "linking ~/.${filename}"
  ln -sf "$DOTFILES_DIR/$source_path" "$HOME/.$filename"
}

# Function to replace a file
replace_file() {
  local source_path=$1
  local filename=$2
  rm -f "$HOME/.$filename"
  link_file "$source_path" "$filename"
}

# Function to safely link individual .config subdirectories
link_config_dir() {
  local config_dir=$1
  local source_path="$DOTFILES_DIR/home/config/$config_dir"
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

# Install dotfiles from home/ directory
install_dotfiles() {
  local replace_all=false

  # Process all files and directories in home/
  for item in home/*; do
    # Skip if home/ directory doesn't exist or is empty
    if [[ ! -e "$item" ]]; then
      continue
    fi

    local filename=$(basename "$item")

    # Handle .config subdirectories specially
    if [[ "$filename" == "config" ]]; then
      echo ""
      echo "🔧 Setting up .config subdirectory management..."
      config_success=true
      for config_item in "$item"/*; do
        if [[ -e "$config_item" ]]; then
          local config_name=$(basename "$config_item")
          echo "Processing config subdirectory: $config_name"
          if ! link_config_dir "$config_name"; then
            config_success=false
          fi
        fi
      done

      if [ "$config_success" = true ]; then
        echo "✅ All .config subdirectories linked successfully"
      else
        echo "⚠️  Some .config subdirectories failed to link"
      fi
      echo ""
      continue
    fi

    # Check if file already exists in home directory
    if [ -e "$HOME/.$filename" ] || [ -L "$HOME/.$filename" ]; then
      # Check if it's already a symlink to our dotfiles
      if [ -L "$HOME/.$filename" ] && [ "$(readlink "$HOME/.$filename")" = "$DOTFILES_DIR/home/$filename" ]; then
        echo "~/.$filename is already linked correctly"
        continue
      fi

      if [ "$replace_all" = true ]; then
        replace_file "home/$filename" "$filename"
      else
        echo -n "overwrite ~/.$filename? [ynaq] "
        read -r answer
        case "$answer" in
          a)
            replace_all=true
            replace_file "home/$filename" "$filename"
            ;;
          y)
            replace_file "home/$filename" "$filename"
            ;;
          q)
            exit
            ;;
          *)
            echo "skipping ~/.$filename"
            ;;
        esac
      fi
    else
      link_file "home/$filename" "$filename"
    fi
  done

  # Create tmp directory
  mkdir -p ~/.tmp
}

# Run the installation
install_dotfiles

echo "Dotfiles installation complete!"