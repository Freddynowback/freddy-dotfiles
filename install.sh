#!/bin/bash

set -e

echo "== FREDDY SYSTEM INSTALLER =="

# =========================
# 1. PACKAGES
# =========================
sudo pacman -Syu --noconfirm

sudo pacman -S --noconfirm \
hyprland \
waybar \
kitty \
rofi \
wlogout \
dunst \
git \
pipewire \
wireplumber \
pavucontrol \
network-manager-applet \
blueman \
brightnessctl \
pamixer \
fastfetch \
xdg-desktop-portal-hyprland \
mpvpaper

# =========================
# 2. COPY CONFIGS
# =========================
echo "Installing configs..."

mkdir -p ~/.config

cp -r config/hypr ~/.config/
cp -r config/waybar ~/.config/
cp -r config/kitty ~/.config/
cp -r config/dunst ~/.config/
cp -r config/rofi ~/.config/
cp -r config/wlogout ~/.config/

# =========================
# 3. WALLPAPERS
# =========================
mkdir -p ~/wallpapers
cp -r wallpapers/* ~/wallpapers/

# =========================
# 4. SERVICES
# =========================
systemctl --user enable pipewire || true
systemctl --user enable wireplumber || true

# =========================
# 5. FINISH
# =========================
echo "DONE. Rebooting recommended..."
