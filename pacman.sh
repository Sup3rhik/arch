#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo
echo "INSTALLING SOFTWARE"
echo

PKGS=(

    # Wine ------------------------------------------------------

    'wine-staging'
    'wine-mono'
    'wine-gecko'

    # GRAPHICS AND DESIGN -------------------------------------------------

    'gcolor2'               # Colorpicker
    'gimp'                  # GNU Image Manipulation Program
    'inkscape'              # Vector image creation app
    'imagemagick'           # Command line image manipulation tool
    'gwenview'              # Image viewer
    'spectacle'             # Tools for screenshots
    'okular'                # PDF viewer

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

    'kdiskmark'             # Disk speed test
    'filelight'             # Drive size
    'partitionmanager'      # Disk utility

    # Office ---------------------------------------------------------

    'libreoffice'           # Office suite
    'korganizer'            # Calendar
    'gnucash'               # Book keeping program
    'nextcloud-client'      # Cloud service
    'kcalc'

    # MEDIA ---------------------------------------------------------------

    'gnome-subtitles'       # Subtitle editor

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

tar -xzvf config.tar.gz
tar -xzvf icons.tar.gz
tar -xzvf local.tar.gz
tar -xzvf Omen.tar.gz
tar -xzvf Dragon.tar.gz
mv .config ~/
mv .icons ~/
mv .local ~/

sudo mv -r Omen /usr/share/sddm/themes/
sudo mv -r Dragon /usr/share/sddm/themes/
sudo rm -rf /usr/share/sddm/themes/maldives
sudo rm -rf /usr/share/sddm/themes/maya
sudo rm -rf /usr/share/sddm/themes/elarun

#   THEME
lookandfeeltool -a org.kde.breezedark.desktop
/usr/lib/plasma-changeicons BeautyLine



echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
