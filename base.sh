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

echo "IME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 IME.localdomain IME" >> /etc/hosts
echo root:passwd | chpasswd

#----------------------------------APPS-----------------------------------

sudo reflector -c Croatia -a 10 --sort rate --save /etc/pacman.d/mirrorlist

pacman -Sy --noconfirm --needed
pacman -S --noconfirm btrfs-progs base-devel linux-zen-headers linux-firmware grub efibootmgr dosfstools os-prober mtools networkmanager dialog wpa_supplicant wireless_tools nano wget reflector snapper dolphin konsole rsync ark unzip ntfs-3g kate bash-completion sof-firmware flatpak kinit ttf-droid ttf-hack ttf-font-awesome otf-font-awesome ttf-lato ttf-liberation ttf-linux-libertine ttf-opensans ttf-roboto ttf-ubuntu-font-family terminus-font ufw cronie ksysguard htop kfind sshfs samba openssh nfs-utils cups nmap print-manager cups-pdf grub-customizer

#----------------------------------BTRFS----------------------------------

sed -i '/MODULES=()/c \MODULES=(btrfs)' /etc/mkinitcpio.conf
mkinitcpio -p linux-zen

#----------------------------------GRUB-----------------------------------

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/c \GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 intel_iommu=on iommu=pt"' /etc/default/grub
sleep 1
sed -i '63s/.//' /etc/default/grub
#sed -i '/#GRUB_DISABLE_OS_PROBER="false"/c \GRUB_DISABLE_OS_PROBER="false"' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

#----------------------------------SERVICES-------------------------------

systemctl enable NetworkManager
sleep 1
systemctl enable bluetooth
sleep 1
systemctl enable cups.service
sleep 1
systemctl enable cronie
sleep 1
systemctl enable sshd
sleep 1
systemctl enable smb
sleep 1
systemctl enable reflector.timer
sleep 1
systemctl enable fstrim.timer
sleep 1
systemctl mask hibernate.target hybrid-sleep.target
sleep 1

#----------------------------------USER------------------------------------

useradd -mG wheel,users,storage,power,lp,adm,optical,audio,video ivo
echo ivo:passwd | chpasswd
echo "ivo ALL=(ALL) ALL" >> /etc/sudoers.d/ivo

#----------------------------------SUDO-----------------------------------

# EDITOR=vim visudo         uncomment      %wheel ALL=(ALL:ALL) ALL
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

#----------------------------------MULTILIB-------------------------------

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

#----------------------------------RAZNO-----------------------------------

ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

echo "Numlock=On" >> /etc/sddm.conf
sed -i '12s/.//' /etc/profile.d/freetype2.sh
echo "PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"" >> /etc/environment
echo "EDITOR="/usr/bin/vim"" >> /etc/environment

#----------------------------------KDE------------------------------------

pacman -S --noconfirm plasma sddm
systemctl enable sddm
sleep 1

tar -xzvf config.tar.gz
tar -xzvf icons.tar.gz
tar -xzvf local.tar.gz

mv .config ~/
mv .icons ~/
mv .local ~/

rm -rf /usr/share/sddm/themes/maldives
rm -rf /usr/share/sddm/themes/maya
rm -rf /usr/share/sddm/themes/elarun
rm -rf /usr/share/sddm/themes/breeze

#----------------------------------EXIT----------------------------------
printf "\e[1;32mDone! Type exit, umount -a and REBOOT.\e[0m"




