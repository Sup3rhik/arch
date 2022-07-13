#!/usr/bin/env bash
#-------------------------------------------------------------------------

sudo pacman -S --noconfirm archlinux-keyring
sudo pacman -Syu --noconfirm

git clone https://aur.archlinux.org/paru-bin
cd paru-bin
sudo pacman -Syu
makepkg -si


echo
echo "INSTALLING SOFTWARE"
echo

PKGS=(

    # Wine ----------------------------------------------------------------

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

    # GAMING --------------------------------------------------------------

    'steam'
    'gamemode'
    'lib32-gamemode'

    # UTILITIES -----------------------------------------------------------

    'bleachbit'
    'neofetch'
    'qbittorrent'
    'kvantum'

    # DISK UTILITIES ------------------------------------------------------

    'kdiskmark'
    'filelight'
    'partitionmanager'

    # Office --------------------------------------------------------------

    'libreoffice'
    'korganizer' 
    'gnucash'
    'nextcloud-client'
    'kcalc'

    # MEDIA ---------------------------------------------------------------

    'gnome-subtitles'
    'vlc'
    'mkvtoolnix-gui'

    # LAPTOP --------------------------------------------------------------

    'intel-undervolt'
    'cpupower'
    'sane-airscan'
    'ipp-usb'
    'skanlite'
    
    # KDE -----------------------------------------------------------------
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

paru -S --noconfirm aic94xx-firmware wd719x-firmware packagekit-qt5 gst-plugin-libde265 peazip-qt5 latte-dock-git ckb-next etcher-bin capt-src mangohud lib32-mangohud heroic-games-launcher-bin proton-ge-custom-bin lutris-git spotify teamviewer zramd vivaldi

#-------------------------------------------------------------------------

echo
echo "FINAL SETUP AND CONFIGURATION"

echo
echo "ENABLING SERVICE DAEMONS"

sudo systemctl enable --now intel-undervolt.service
echo "  intel-undervolt enabled and started"
sudo systemctl enable --now auto-cpufreq.service
echo "  auto-cpufreq enabled and started"
sudo systemctl enable teamviewerd
echo "  teamviewerd enabled"
sudo systemctl enable --now ckb-next-daemon
echo "  iCue enabled and started"
sudo systemctl enable --now zramd.service
echo "  SWAP enabled and started"
sudo systemctl enable sddm.service
echo "  SDDM enabled"


# ------------------------------------------------------------------------

echo
echo "ENABLING FIREWALL"

sudo systemctl enable ufw.service --now
echo "  firewall enabled and started"
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/24
#sudo ufw allow 1714:1764/udp
#sudo ufw allow 1714:1764/tcp
sudo ufw reload

# ------------------------------------------------------------------------

#   THEME

sleep 3
lookandfeeltool -a org.kde.breezedark.desktop
sleep 3
/usr/lib/plasma-changeicons BeautyLine
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


echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot

