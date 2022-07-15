#!/usr/bin/env bash
#-------------------------------------------------------------------------

sudo pacman -S --noconfirm archlinux-keyring
sudo pacman -Syu --noconfirm

git clone https://aur.archlinux.org/paru-bin
cd paru-bin
sudo pacman -Syu
makepkg -si
cd ..

# ---------------------------------APPS-PACMAN----------------------------------

PKGS=(

    # NVIDIA---------------------------------------------------------------

    'nvidia-dkms'
    'nvidia-utils'
    'lib32-nvidia-utils'
    'nvidia-settings'

    # Wine ----------------------------------------------------------------

    'wine'
    'winetricks'
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

    # SCANER --------------------------------------------------------------

    'sane-airscan'
    'ipp-usb'
    'skanlite'

    # LAPTOP --------------------------------------------------------------

    'intel-undervolt'
    'cpupower'
    
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo

# ---------------------------------APPS-PARU--------------------------------------

paru -S --noconfirm aic94xx-firmware wd719x-firmware packagekit-qt5 gst-plugin-libde265 peazip-qt5 latte-dock-git ckb-next vivaldi brave-bin
paru -S --noconfirm etcher-bin mangohud lib32-mangohud heroic-games-launcher-bin proton-ge-custom-bin lutris-git spotify teamviewer zramd 
paru -S --noconfirm auto-cpufreq capt-src

# ---------------------------------SERVICES---------------------------------------

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

# ---------------------------------FIREWALL---------------------------------------

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

# ---------------------------------THEME---------------------------------------

tar -xzvf config.tar.gz
tar -xzvf icons.tar.gz
tar -xzvf local.tar.gz
tar -xzvf Omen.tar.gz

mv .config ~/
mv .icons ~/
mv .local ~/
sudo mv Omen /usr/share/sddm/themes/

sudo rm -rf /usr/share/sddm/themes/maldives
sudo rm -rf /usr/share/sddm/themes/maya
sudo rm -rf /usr/share/sddm/themes/elarun
sudo rm -rf /usr/share/sddm/themes/breeze

lookandfeeltool -a org.kde.breezedark.desktop
/usr/lib/plasma-changeicons BeautyLine

# ---------------------------------FSTAB---------------------------------------

sudo sed -i '$ a # \t\t nvme1n1p3 - Linux SSD' /etc/fstab
sudo sed -i '$ a UUID=c388d55f-1412-4413-863d-a2e3104fc66a\t/media/btrfs/ssd\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a #HDD' /etc/fstab
sudo sed -i '$ a # \t\t sda1 - NEXTCLOUD' /etc/fstab
sudo sed -i '$ a UUID=fdd0754d-49f0-4802-80ee-40f23d641fea\t/media/btrfs/nc\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t sda2 - STORAGE' /etc/fstab
sudo sed -i '$ a UUID=2750d2ff-3da2-4904-9a9f-b73ae91a8fbe\t/media/btrfs/hdd\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t sda3 - BACKUPS' /etc/fstab
sudo sed -i '$ a UUID=a3f1d11d-0fcc-46b5-9821-9801c2206b97\t/media/btrfs/bkp\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a #WINDOWS' /etc/fstab
sudo sed -i '$ a # \t\t nvme0n1p3 - Windows 10' /etc/fstab
sudo sed -i '$ a UUID=82062AED062AE1C1\t/media/btrfs/hdd\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t nvme0n1p4 - Windows SSD' /etc/fstab
sudo sed -i '$ a UUID=C88A20498A20367A\t/media/btrfs/bkp\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

# ---------------------------------REBOOT---------------------------------------

echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
