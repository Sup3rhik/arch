#!/usr/bin/env bash

#-----------------------------------PARU----------------------------------

git clone https://aur.archlinux.org/paru-bin
cd paru-bin
sudo pacman -Syu --noconfirm
makepkg -si --noconfirm

# ---------------------------------APPS-----------------------------------

paru -S --noconfirm aic94xx-firmware wd719x-firmware brave-bin zramd
sudo systemctl enable --now zramd.service
echo "  SWAP enabled and started"

echo
/bin/echo -e "\e[1;32mDONE & REBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
