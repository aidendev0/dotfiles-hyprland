#!/bin/bash

echo "Checking yay..."
if ! command -v yay &> /dev/null; then
    echo "yay doesn't found. Installing yay..."
    sudo pacman -Syyu
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git || { echo "Can't clone yay repository, sorry."; exit 1; }
    cd yay || { echo "Can't dhange directory to yay, sorry."; exit 1; }
    makepkg -si --noconfirm || { echo "Can't install yay, sorry."; exit 1; }
    cd ..
    rm -rf yay
fi

echo "Installing dependencies..."
packages=(
  hyprland
  kitty
  waybar
  swaybg
  swaylock-effects
  wofi
  wlogout
  mako
  thunar
  ttf-jetbrains-mono-nerd
  noto-fonts-emoji
  polkit-gnome
  swappy
  grim
  slurp
  xdg-desktop-portal-hyprland
)

yay -S --noconfirm "${packages[@]}" || { echo "Can't install packages, sorry."; exit 1; }

echo "Dependency installation complete."