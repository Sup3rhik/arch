#!/bin/bash

#----------------------------------VRIJEME--------------------------------

ln -sf /usr/share/zoneinfo/Europe/Zagreb /etc/localtime
hwclock --systohc
timedatectl set-ntp true
timedatectl set-local-rtc 1 --adjust-system-clock

#----------------------------------LOCALE---------------------------------

sed -i '177s/.//' /etc/locale.gen
sed -i '279s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=croat" >> /etc/vconsole.conf

#----------------------------------NAME-----------------------------------

echo "arch-IME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch-IME.localdomain arch-IME" >> /etc/hosts
echo root:passwd | chpasswd

#----------------------------------SUDO-----------------------------------

# EDITOR=vim visudo         uncomment      %wheel ALL=(ALL:ALL) ALL
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

#----------------------------------PARU-----------------------------------

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

#----------------------------------APPS-------------------------------------

pacman -Sy --noconfirm --needed
pacman -S --noconfirm btrfs-progs base-devel linux-zen-headers linux-firmware grub efibootmgr dosfstools os-prober mtools networkmanager dialog wpa_supplicant wireless_tools nano wget reflector snapper dolphin konsole rsync ark unzip ntfs-3g kate bash-completion sof-firmware flatpak kinit ttf-droid ttf-hack ttf-font-awesome otf-font-awesome ttf-lato ttf-liberation ttf-linux-libertine ttf-opensans ttf-roboto ttf-ubuntu-font-family terminus-font ufw cronie ksysguard htop kfind sshfs samba openssh nfs-utils cups nmap print-manager cups-pdf grub-customizer

#----------------------------------GRUB-------------------------------------

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

#----------------------------------SERVICES---------------------------------

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable cronie
systemctl enable sshd
systemctl enable smb
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl mask hibernate.target hybrid-sleep.target

#----------------------------------USER-------------------------------------

useradd -mG wheel,users,storage,power,lp,adm,optical,audio,video ivo
echo ivo:passwd | chpasswd
echo "ivo ALL=(ALL) ALL" >> /etc/sudoers.d/ivo

#----------------------------------RAZNO------------------------------------

ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
sudo reflector -c Croatia -a 10 --sort rate --save /etc/pacman.d/mirrorlist
echo "Numlock=On" >> /etc/sddm.conf
sed -i '12s/.//' /etc/profile.d/freetype2.sh
echo "PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"" >> /etc/environment
echo "EDITOR="/usr/bin/vim"" >> /etc/environment
localectl --no-ask-password set-keymap hr

#----------------------------------KDE------------------------------------

pacman -S --noconfirm plasma sddm
# systemctl enable sddm

#----------------------------------EXIT----------------------------------
printf "\e[1;32mDone! Type EXIT, UMOUNT and REBOOT.\e[0m"




