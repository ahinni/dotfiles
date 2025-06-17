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

# Function to handle .config subdirectories
link_config_dir() {
  local config_dir=$1
  echo "linking ~/.config/${config_dir}"

  # Create ~/.config if it doesn't exist
  mkdir -p "$HOME/.config"

  # Remove existing config directory if it exists
  rm -rf "$HOME/.config/$config_dir"

  # Link the config directory
  ln -sf "$DOTFILES_DIR/home/config/$config_dir" "$HOME/.config/$config_dir"
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
      for config_item in "$item"/*; do
        if [[ -e "$config_item" ]]; then
          local config_name=$(basename "$config_item")
          link_config_dir "$config_name"
        fi
      done
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