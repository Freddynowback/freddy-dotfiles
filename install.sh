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
sddm \
git \
pipewire \
wireplumber \
pavucontrol \
network-manager-applet \
blueman \
brightnessctl \
pamixer \
qt5-graphicaleffects \
qt5-quickcontrols2 \
qt5-svg \
fastfetch \
hyprlock \
thunar \
dolphin \
ttf-jetbrains-mono-nerd \
networkmanager \
vivaldi \
polkit-kde-agent \
xdg-desktop-portal-hyprland \
mpvpaper

# =========================
# 2. COPY CONFIGS
# =========================
echo "Installing configs..."

mkdir -p ~/.config
# =========================
# LOCAL BIN SCRIPTS
# =========================

mkdir -p ~/.local/bin

cp -r local/bin/* ~/.local/bin/

chmod +x ~/.local/bin/*

cp -r config/hypr ~/.config/
cp -r config/waybar ~/.config/
cp -r config/kitty ~/.config/
cp -r config/dunst ~/.config/
cp -r config/rofi ~/.config/
cp -r config/wlogout ~/.config/

# =========================
# SDDM
# =========================

sudo mkdir -p /etc/sddm.conf.d

if [ -f config/sddm/sddm.conf ]; then
    sudo cp config/sddm/sddm.conf /etc/
fi

if [ -d config/sddm/sddm.conf.d ]; then
    sudo cp -r config/sddm/sddm.conf.d/* /etc/sddm.conf.d/
fi

if [ -d config/sddm/themes ]; then
    sudo cp -r config/sddm/themes/* /usr/share/sddm/themes/
fi

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
sudo systemctl enable NetworkManager
sudo systemctl enable sddm
echo "export XDG_CURRENT_DESKTOP=Hyprland" >> ~/.profile
echo "export XDG_SESSION_TYPE=wayland" >> ~/.profile

# =========================
# 5. FINISH
# =========================
echo "DONE. Rebooting recommended..."
