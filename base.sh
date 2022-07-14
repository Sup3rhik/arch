#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Zagreb /etc/localtime
hwclock --systohc
timedatectl set-ntp true
timedatectl set-local-rtc 1 --adjust-system-clock

sed -i '177s/.//' /etc/locale.gen
sed -i '279s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=croat" >> /etc/vconsole.conf
localectl --no-ask-password set-keymap hr

echo "arch-IME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch-IME.localdomain arch-IME" >> /etc/hosts

echo root:passwd | chpasswd

# Add sudo no password rights
#sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
#sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

pacman -Sy --noconfirm --needed
pacman -S btrfs-progs base-devel linux-zen-headers linux-firmware grub efibootmgr dosfstools os-prober mtools networkmanager dialog wpa_supplicant wireless_tools nano wget reflector snapper dolphin konsole rsync ark unzip ntfs-3g kate bash-completion sof-firmware flatpak kinit ttf-droid ttf-hack ttf-font-awesome otf-font-awesome ttf-lato ttf-liberation ttf-linux-libertine ttf-opensans ttf-roboto ttf-ubuntu-font-family terminus-font ufw cronie ksysguard htop kfind sshfs samba openssh nfs-utils cups nmap print-manager cups-pdf grub-customizer

#pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable cronie
systemctl enable sshd
systemctl enable smb
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl mask hibernate.target hybrid-sleep.target


useradd -mG wheel,users,storage,power,lp,adm,optical,audio,video ivo
echo ivo:passwd | chpasswd
echo "ivo ALL=(ALL) ALL" >> /etc/sudoers.d/ivo

ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
sudo reflector -c Croatia -a 10 --sort rate --save /etc/pacman.d/mirrorlist
echo "Numlock=On" >> /etc/sddm.conf
sed -i '12s/.//' /etc/profile.d/freetype2.sh
echo "PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"" >> /etc/environment
echo "EDITOR="/usr/bin/vim"" >> /etc/environment

#----------------------------------THEME----------------------------------
tar -xzvf config.tar.gz
tar -xzvf icons.tar.gz
tar -xzvf local.tar.gz
tar -xzvf Omen.tar.gz
tar -xzvf Dragon.tar.gz
mv .config ~/
mv .icons ~/
mv .local ~/

sudo mv Omen /usr/share/sddm/themes/
sudo mv Dragon /usr/share/sddm/themes/
sudo rm -rf /usr/share/sddm/themes/maldives
sudo rm -rf /usr/share/sddm/themes/maya
sudo rm -rf /usr/share/sddm/themes/elarun
sudo rm -rf /usr/share/sddm/themes/breeze

pacman -S --noconfirm plasma sddm
systemctl enable sddm

printf "\e[1;32mDone! Type EXIT, UMOUNT and REBOOT.\e[0m"




