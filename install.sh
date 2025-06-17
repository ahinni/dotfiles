#!/bin/bash

# Get the absolute path of the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to link a file
link_file() {
  local file=$1
  echo "linking ~/.${file}"
  ln -sf "$DOTFILES_DIR/$file" "$HOME/.$file"
}

# Function to replace a file
replace_file() {
  local file=$1
  rm -f "$HOME/.$file"
  link_file "$file"
}

# Install dotfiles
install_dotfiles() {
  local replace_all=false

  for file in *; do
    # Skip certain files
    if [[ "$file" == "Rakefile" || "$file" == "README.md" || "$file" == "LICENSE" ||
          "$file" == "id_dsa.pub" || "$file" == "install.sh" ||
          "$file" == "Dockerfile.test" || "$file" == "test-dotfiles.sh" ]]; then
      continue
    fi

    # Skip files with "ignore" in the name
    if [[ "$file" == *ignore* ]]; then
      continue
    fi

    # Check if file already exists in home directory
    if [ -e "$HOME/.$file" ] || [ -L "$HOME/.$file" ]; then
      # Check if it's already a symlink to our dotfiles
      if [ -L "$HOME/.$file" ] && [ "$(readlink "$HOME/.$file")" = "$DOTFILES_DIR/$file" ]; then
        echo "~/.$file is already linked correctly"
        continue
      fi

      if [ "$replace_all" = true ]; then
        replace_file "$file"
      else
        echo -n "overwrite ~/.$file? [ynaq] "
        read -r answer
        case "$answer" in
          a)
            replace_all=true
            replace_file "$file"
            ;;
          y)
            replace_file "$file"
            ;;
          q)
            exit
            ;;
          *)
            echo "skipping ~/.$file"
            ;;
        esac
      fi
    else
      link_file "$file"
    fi
  done

  # Create tmp directory
  mkdir -p ~/.tmp
}

# Run the installation
install_dotfiles

echo "Dotfiles installation complete!"