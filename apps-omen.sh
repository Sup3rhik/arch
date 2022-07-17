#!/usr/bin/env bash
#-------------------------------------------------------------------------

sudo pacman -S --noconfirm archlinux-keyring
sudo pacman -Syu --noconfirm
tar -xzvf Archive.tar.gz

#---------------------------------PARU-----------------------------------------

git clone https://aur.archlinux.org/paru-bin
cd paru-bin
sudo pacman -Syu
makepkg -si
cd ..

#-----------------------------------SYNTH-SHELL-----------------------------------

git clone --recursive https://github.com/andresgongora/synth-shell.git
chmod +x synth-shell/setup.sh
cd synth-shell
./setup.sh
cd ..

#---------------------------------APPS-PACMAN----------------------------------

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
    'kdeconnect'

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

    # VIRT MANAGER---------------------------------------------------------

    'qemu'
    'libvirt'
    'edk2-ovmf'
    'virt-manager'
    'vde2'
    'dnsmasq'
    'bridge-utils'
    'ovmf'
    'openbsd-netcat'

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

pacman -S iptables-nft

# ---------------------------------APPS-PARU--------------------------------------

paru -S --noconfirm aic94xx-firmware wd719x-firmware packagekit-qt5 gst-plugin-libde265 peazip-qt5 latte-dock-git ckb-next vivaldi brave-bin etcher-bin mangohud lib32-mangohud heroic-games-launcher-bin proton-ge-custom-bin protonup-qt lutris-git spotify teamviewer zramd auto-cpufreq capt-src

#----------------------------------VIRT MANAGER-----------------------------------

sudo mkdir -p /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
sudo mkdir -p /etc/libvirt/hooks/qemu.d/Windows/prepare/begin
sudo mkdir -p /etc/libvirt/hooks/qemu.d/Windows/release/end

sudo tar -C /etc/libvirt/hooks/qemu.d/Windows/prepare/begin/ -xzvf start.tar.gz
sudo chmod +x /etc/libvirt/hooks/qemu.d/Windows/prepare/begin/start.sh

sudo tar -C /etc/libvirt/hooks/qemu.d/Windows/release/end/ -xzvf revert.tar.gz
sudo chmod +x /etc/libvirt/hooks/qemu.d/Windows/release/end/revert.sh

sudo touch /etc/libvirt/hooks/kvm.conf
sudo gawk -i inplace 'BEGINFILE{print" "} 1' /etc/libvirt/hooks/kvm.conf
sudo sed -i '$ a\VIRSH_GPU_CPU=pci_0000_00_01_0' /etc/libvirt/hooks/kvm.conf
sudo sed -i '$ a\VIRSH_GPU_VIDEO=pci_0000_01_00_0' /etc/libvirt/hooks/kvm.conf
sudo sed -i '$ a\VIRSH_GPU_AUDIO=pci_0000_01_00_1' /etc/libvirt/hooks/kvm.conf
sudo sed -i '$ a\VIRSH_GPU_USB=pci_0000_01_00_2' /etc/libvirt/hooks/kvm.conf
sudo sed -i '$ a\VIRSH_GPU_SBC=pci_0000_01_00_3' /etc/libvirt/hooks/kvm.conf

sudo sed -i '81s/.//' /etc/libvirt/libvirtd.conf
sudo sed -i '104s/.//' /etc/libvirt/libvirtd.conf
sudo sed -i '$ a\log_filters="1:qemu"' /etc/libvirt/libvirtd.conf
sudo sed -i '$ a\log_outputs="1:file:/var/log/libvirt/libvirtd.log"' /etc/libvirt/libvirtd.conf

sudo usermod -a -G libvirt $(whoami)

sudo sed -i '/#user = "libvirt-qemu"/c \user = "ivo"' /etc/libvirt/qemu.conf
sudo sed -i '/#group = "libvirt-qemu"/c \group = "wheel"' /etc/libvirt/qemu.conf

sudo mkdir -p /var/lib/libvirt/vbios
sudo tar -C /var/lib/libvirt/vbios -xzvf gpu.tar.gz
sudo chmod 644 /var/lib/libvirt/vbios/gpu.rom

#-----------------------------------INTEL-UNDERVOLT-------------------------------

sudo sed -i '/enable no/c \enable yes' /etc/intel-undervolt.conf
sudo sed -i '/undervolt 0 '"'"'CPU'"'"' 0/c \undervolt 0 '"'"'CPU'"'"' -150' /etc/intel-undervolt.conf
sudo sed -i '/undervolt 2 '"'"'CPU Cache'"'"' 0/c \undervolt 2 '"'"'CPU Cache'"'"' -150' /etc/intel-undervolt.conf

#-----------------------------------SAMBA-----------------------------------------

sudo tar -C /etc/samba/ -xzvf smb.tar.gz

#-----------------------------------CANON-LBP6310---------------------------------

lpadmin -p LBP6310 -m CNCUPSLBP6310CAPTK.ppd -v ccp://localhost:59687 -E
sudo ccpdadmin -p LBP6310 -o net:192.168.0.250
sudo systemctl enable --now ccpd.service
sudo tar -C /etc/systemd/system/ -xzvf ccpd-service.tar.gz
sudo tar -C /usr/local/sbin/ -xzvf ccpd-sh.tar.gz
sudo chmod +x /usr/local/sbin/restartccpd.sh
sudo systemctl enable restartccpd.service

#-----------------------------------SUDOERS---------------------------------------

sudo sed -i '$ a\ivo    ALL=(ALL)    NOPASSWD: /usr/bin/virsh' /etc/sudoers
sudo sed -i '$ a\ivo    ALL=(ALL)    NOPASSWD: /usr/bin/cpupower' /etc/sudoers

# ---------------------------------SERVICES---------------------------------------

sudo systemctl enable --now intel-undervolt.service
echo "  intel-undervolt enabled and started"
sudo systemctl enable --now cpupower.service
echo "  cpupower enabled and started"
sudo systemctl enable --now auto-cpufreq.service
echo "  auto-cpufreq enabled and started"
sudo systemctl enable teamviewerd
echo "  teamviewerd enabled"
sudo systemctl enable --now ckb-next-daemon
echo "  iCue enabled and started"
sudo systemctl enable --now zramd.service
echo "  SWAP enabled and started"
sudo sed -i '/#DefaultTimeoutStopSec=90s/c \DefaultTimeoutStopSec=10s' /etc/systemd/system.conf
sudo systemctl enable --now libvirtd.service
echo "  libvirtd enabled and started"
sudo systemctl enable --now virtlogd.socket
echo "  virtlogd enabled and started"
sudo virsh net-autostart default
echo "  net-autostart enabled"
sudo virsh net-start default
echo "  net-start enabled"

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

tar -xzvf Omen.tar.gz
sudo mv Omen /usr/share/sddm/themes/

lookandfeeltool -a org.kde.breezedark.desktop
sleep 2
/usr/lib/plasma-changeicons BeautyLine

# ---------------------------------FSTAB---------------------------------------

sudo sed -i '$ a # \t\t nvme1n1p3 - Linux SSD' /etc/fstab
sudo sed -i '$ a #UUID=a4821538-7f3b-4106-872e-e98fbc7952db\t/media/btrfs/ssd\tbtrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a #HDD' /etc/fstab
sudo sed -i '$ a # \t\t sda1 - NEXTCLOUD' /etc/fstab
sudo sed -i '$ a UUID=fdd0754d-49f0-4802-80ee-40f23d641fea\t/media/btrfs/nc\tbtrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t sda2 - STORAGE' /etc/fstab
sudo sed -i '$ a UUID=2750d2ff-3da2-4904-9a9f-b73ae91a8fbe\t/media/btrfs/hdd\tbtrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t sda3 - BACKUPS' /etc/fstab
sudo sed -i '$ a UUID=a3f1d11d-0fcc-46b5-9821-9801c2206b97\t/media/btrfs/bkp\tbtrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a #WINDOWS' /etc/fstab
sudo sed -i '$ a # \t\t nvme0n1p3 - Windows 10' /etc/fstab
sudo sed -i '$ a UUID=82062AED062AE1C1\t/media/ntfs/hdd\tntfs-3g\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t nvme0n1p4 - Windows SSD' /etc/fstab
sudo sed -i '$ a UUID=C88A20498A20367A\t/media/ntfs/bkp\tntfs-3g\tdefaults,rw,relatime\t0\t0' /etc/fstab

# ---------------------------------REBOOT---------------------------------------

echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
