#!/bin/bash

# GNOME keybinding customizations
# Only runs on systems with GNOME Shell installed

# Check if gsettings exists
if ! command -v gsettings &> /dev/null; then
  exit 0
fi

# Check if GNOME Shell is installed
if ! gsettings list-schemas 2>/dev/null | grep -q "org.gnome.shell"; then
  exit 0
fi

echo "Configuring GNOME keybindings..."

# Super+Space for overview/launcher (remove conflicts first)
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['XF86Keyboard']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift>XF86Keyboard']"
gsettings set org.freedesktop.ibus.general.hotkey triggers "[]"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>space']"

# Disable overlay key (tapping Super alone)
gsettings set org.gnome.mutter overlay-key ''

# Super+P for display switching (use dedicated key only)
gsettings set org.gnome.mutter.keybindings switch-monitor "['XF86Display']"

echo "GNOME keybindings configured"
