#!/usr/bin/env bash
#-------------------------------------------------------------------------

sudo pacman -Syu --noconfirm

#-----------------------------------PARU----------------------------------

git clone https://aur.archlinux.org/paru-bin
cd paru-bin
sudo pacman -Syu
makepkg -si --noconfirm
cd ..

# ---------------------------------APPS-----------------------------------

paru -S --noconfirm aic94xx-firmware wd719x-firmware brave-bin zramd
sudo systemctl enable --now zramd.service
echo "  SWAP enabled and started "

lookandfeeltool -a org.kde.breezedark.desktop
/usr/lib/plasma-changeicons BeautyLine

echo
/bin/echo -e "\e[1;32mD O N E\e[0m"
