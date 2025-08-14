#!/bin/bash

DOTFILES_REPO="https://github.com/aidendev0/dotfiles-hyprland/tree/testing"
TEMP_DIR="$HOME/dotfiles-temp"
DOTFILES_DIR="$HOME/.dotfiles"

create_symlink() {
local source_path="$1"
local target_path="$2"

if [ -e "$target_path" ] || [ -L "$target_path" ]; then
echo " > File or directory already exists: $target_path. Moving to $target_path.bak"
mv "$target_path" "$target_path.bak"
fi

mkdir -p "$(dirname "$target_path")"
echo " > Creating symlink: $source_path -> $target_path"
ln -sfn "$source_path" "$target_path"
}

echo "Starting dotfiles installation script..."

echo "1. Cloning dotfiles repository..."
if [ -d "$DOTFILES_DIR" ]; then
echo " > Directory $DOTFILES_DIR already exists. Updating..."
cd "$DOTFILES_DIR" || exit
git pull
else
git clone --branch testing --depth=1 "$DOTFILES_REPO" "$DOTFILES_DIR" || { echo "Failed to clone repository. Check URL."; exit 1; }
cd "$DOTFILES_DIR" || exit
fi
echo "Cloning completed."

echo ""
echo "2. Running install-dependencies.sh to install dependencies..."
if [ -f "install-dependencies.sh" ]; then
chmod +x install-dependencies.sh
./install-dependencies.sh
else
echo " > File install-dependencies.sh not found. Skipping this step."
fi
echo "Dependencies installation completed."

echo ""
echo "3. Installing configurations..."

echo " > Installing Hyprland configurations..."
create_symlink "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"

echo " > Installing mako configurations..."
create_symlink "$DOTFILES_DIR/mako" "$HOME/.config/mako"

echo " > Installing swaylock configurations..."
create_symlink "$DOTFILES_DIR/swaylock" "$HOME/.config/swaylock"

echo " > Installing waybar configurations..."
create_symlink "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"

echo " > Installing wofi configurations..."
create_symlink "$DOTFILES_DIR/wofi" "$HOME/.config/wofi"

echo ""
echo "Dotfiles installation completed."
echo "Please, reboot your computer"
