#!/usr/bin/env bash
#-------------------------------------------------------------------------
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------


paru -S --noconfirm vivaldi fwupd packagekit-qt5 flatpak gst-plugin-libde265 peazip-qt5 latte-dock-git ckb-next etcher-bin capt-src mangohud lib32-mangohud heroic-games-launcher-bin proton-ge-custom-bin lutris-git spotify teamviewer zramd

#-------------------------------------------------------------------------

echo
echo "FINAL SETUP AND CONFIGURATION"

echo
echo "ENABLING SERVICE DAEMONS"

sudo systemctl enable teamviewerd
echo "  teamviewerd enabled"
sudo systemctl enable --now ckb-next-daemon
echo "  iCue enabled and started"

sudo systemctl enable --now zramd.service
echo "  SWAP enabled and started"
# ------------------------------------------------------------------------

echo
echo "ENABLING FIREWALL"

sudo systemctl enable ufw.service --now
echo "  firewall enabled and started"
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/24
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload

# ------------------------------------------------------------------------

echo "Done!"
echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
