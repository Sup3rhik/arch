#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

sudo pacman -S --noconfirm archlinux-keyring
sudo pacman -Syu --noconfirm

echo
echo "INSTALLING SOFTWARE"
echo

PKGS=(

    # Wine ------------------------------------------------------

    'wine-staging'
    'wine-mono'
    'wine-gecko'

    # GRAPHICS AND DESIGN -------------------------------------------------

    'gcolor2'
    'gimp'   
    'inkscape'
    'imagemagick'
    'gwenview'   
    'spectacle'  
    'okular'     

    # GAMING --------------------------------------------------

    'steam'
    'gamemode'
    'lib32-gamemode'

    # UTILITIES --------------------------------------------------

    'bleachbit'
    'neofetch'
    'qbittorrent'
    'kvantum'

    # DISK UTILITIES ------------------------------------------------------

    'kdiskmark'
    'filelight'
    'partitionmanager'

    # Office ---------------------------------------------------------

    'libreoffice'
    'korganizer' 
    'gnucash'
    'nextcloud-client'
    'kcalc'

    # MEDIA ---------------------------------------------------------------

    'gnome-subtitles'
    'vlc'
    'mkvtoolnix-gui'

    # VIRTUALIZATION ------------------------------------------------------

    'qemu'
    'libvirt'
    'edk2-ovmf'
    'virt-manager'
    'vde2'
    'dnsmasq'
    'bridge-utils'
    'iptables-nft'
    'ovmf'
    'openbsd-netcat'

    # LAPTOP ------------------------------------------------------
    'intel-undervolt'
    'cpupower'
    'sane-airscan'
    'ipp-usb'
    'skanlite'
    
    # KDE ------------------------------------------------------
    'plasma'
    'sddm'

)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo

#-------------------------------------------------------------------------
sudo sed -i '81s/.//' /etc/libvirt/libvirtd.conf
sudo sed -i '104s/.//' /etc/libvirt/libvirtd.conf

#-------------------------------------------------------------------------

echo
echo "FINAL SETUP AND CONFIGURATION"

echo
echo "ENABLING SERVICE DAEMONS"

sudo systemctl enable --now libvirtd.service
echo "  libvirtd enabled and started"
sudo systemctl enable --now virtlogd.socket
echo "  virtlogd enabled and started"
sudo virsh net-autostart default
echo "  net-autostart enabled"
sudo virsh net-start default
echo "  net-start enabled"

sudo systemctl enable --now intel-undervolt.service
echo "  intel-undervolt enabled and started"
sudo systemctl enable --now auto-cpufreq.service
echo "  auto-cpufreq enabled and started"

sudo systemctl enable sddm.service
sudo reflector -c Croatia -a 10 --sort rate --save /etc/pacman.d/mirrorlist
# ------------------------------------------------------------------------

echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
