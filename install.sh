#!/bin/bash

set -e

echo "== FREDDY SYSTEM INSTALLER =="

# =========================
# 1. UPDATE SYSTEM
# =========================

sudo pacman -Syu --noconfirm

# =========================
# 2. OFFICIAL REPO PACKAGES
# =========================

PACMAN_PACKAGES=(
    hyprland
    waybar
    kitty
    rofi
    wlogout
    dunst
    sddm
    git
    pipewire
    wireplumber
    pavucontrol
    network-manager-applet
    blueman
    brightnessctl
    pamixer
    qt5-graphicaleffects
    qt5-quickcontrols2
    qt5-svg
    fastfetch
    hyprlock
    thunar
    dolphin
    ttf-jetbrains-mono-nerd
    networkmanager
    polkit-kde-agent
    xdg-desktop-portal-hyprland
)

sudo pacman -S --noconfirm "${PACMAN_PACKAGES[@]}"

# =========================
# 3. INSTALL YAY (IF NEEDED)
# =========================

if ! command -v yay &> /dev/null; then
    echo "Installing yay..."

    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd ~

fi

# =========================
# 4. AUR PACKAGES
# =========================

AUR_PACKAGES=(
    vivaldi
    mpvpaper
)

yay -S --noconfirm "${AUR_PACKAGES[@]}"

# =========================
# 5. COPY CONFIGS
# =========================

echo "Installing configs..."

mkdir -p ~/.config
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
# 6. SDDM
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
# 7. WALLPAPERS
# =========================

mkdir -p ~/wallpapers
cp -r wallpapers/* ~/wallpapers/

# =========================
# 8. ENABLE SERVICES
# =========================

systemctl --user enable pipewire || true
systemctl --user enable wireplumber || true

sudo systemctl enable NetworkManager
sudo systemctl enable sddm

# =========================
# 9. ENVIRONMENT VARIABLES
# =========================

grep -qxF 'export XDG_CURRENT_DESKTOP=Hyprland' ~/.profile || \
echo 'export XDG_CURRENT_DESKTOP=Hyprland' >> ~/.profile

grep -qxF 'export XDG_SESSION_TYPE=wayland' ~/.profile || \
echo 'export XDG_SESSION_TYPE=wayland' >> ~/.profile

# =========================
# 10. FINISH
# =========================

echo "DONE. Reboot recommended."
