#!/usr/bin/env bash

#-----------------------------------PARU----------------------------------

git clone https://aur.archlinux.org/paru-bin
cd paru-bin
sudo pacman -Syu --noconfirm
makepkg -si --noconfirm

# ---------------------------------APPS-----------------------------------

paru -S --noconfirm aic94xx-firmware wd719x-firmware brave-bin zramd snap-pac-grub snapper-gui
sudo systemctl enable --now zramd.service
echo "  SWAP enabled and started"

#----------------------------------SNAPPER-----------------------------------

su
umount /.snapshots
rm -r /.snapshots
snapper -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
btrfs subvolume set-default 256 /
chown -R :wheel /.snapshots/

sed -i '/ALLOW_GROUPS=""/c \ALLOW_GROUPS="wheel"' /etc/snapper/configs/root
sed -i '/TIMELINE_LIMIT_HOURLY="10"/c \TIMELINE_LIMIT_HOURLY="5"' /etc/snapper/configs/root
sed -i '/TIMELINE_LIMIT_DAILY="10"/c \TIMELINE_LIMIT_DAILY="7"' /etc/snapper/configs/root
sed -i '/TIMELINE_LIMIT_MONTHLY="10"/c \TIMELINE_LIMIT_MONTHLY="0"' /etc/snapper/configs/root
sed -i '/TIMELINE_LIMIT_YEARLY="10"/c \TIMELINE_LIMIT_YEARLY="0"' /etc/snapper/configs/root

systemctl enable --now grub-btrfs.path
echo " grub-btrfs enabled "
systemctl enable --now snapper-timeline.timer
echo " snapper-timeline enabled "
systemctl enable --now snapper-cleanup.timer
echo " snapper-cleanup enabled "



echo
/bin/echo -e "\e[1;32mDONE & REBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
