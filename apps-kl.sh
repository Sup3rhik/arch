#!/usr/bin/env bash
#-------------------------------------------------------------------------

sudo pacman -S --noconfirm archlinux-keyring
sudo pacman -Syu --noconfirm
tar -xzvf Archive.tar.gz

#---------------------------------APPS-PACMAN-----------------------------

PKGS=(

    # NVIDIA---------------------------------------------------------------

#    'nvidia-dkms'
#    'nvidia-utils'
#    'lib32-nvidia-utils'
#    'nvidia-settings'

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
    'stress'
    'packagekit-qt5'

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

#    'sane-airscan'
#    'ipp-usb'
#    'skanlite'

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


)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo

# ---------------------------------APPS-PARU--------------------------------------

paru -S --noconfirm  gst-plugin-libde265 peazip-qt5 latte-dock-git ckb-next vivaldi etcher-bin mangohud lib32-mangohud heroic-games-launcher-bin proton-ge-custom-bin protonup-qt lutris-git spotify teamviewer capt-src

#----------------------------------VIRT MANAGER-----------------------------------

sudo mkdir -p /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
sudo mkdir -p /etc/libvirt/hooks/qemu.d/Windows/prepare/begin
sudo mkdir -p /etc/libvirt/hooks/qemu.d/Windows/release/end

sudo tar -C /etc/libvirt/hooks/qemu.d/Windows/prepare/begin/ -xzvf start.tar.gz
rm start.tar.gz
sudo chmod +x /etc/libvirt/hooks/qemu.d/Windows/prepare/begin/start.sh

sudo tar -C /etc/libvirt/hooks/qemu.d/Windows/release/end/ -xzvf revert.tar.gz
rm revert.tar.gz
sudo chmod +x /etc/libvirt/hooks/qemu.d/Windows/release/end/revert.sh

sudo touch /etc/libvirt/hooks/kvm.conf
sudo gawk -i inplace 'BEGINFILE{print" "} 1' /etc/libvirt/hooks/kvm.conf
sudo sed -i '$ a\VIRSH_GPU_CPU=pci_0000_00_01_0' /etc/libvirt/hooks/kvm.conf
sudo sed -i '$ a\VIRSH_GPU_VIDEO=pci_0000_01_00_0' /etc/libvirt/hooks/kvm.conf
sudo sed -i '$ a\VIRSH_GPU_AUDIO=pci_0000_01_00_1' /etc/libvirt/hooks/kvm.conf
#sudo sed -i '$ a\VIRSH_GPU_USB=pci_0000_01_00_2' /etc/libvirt/hooks/kvm.conf
#sudo sed -i '$ a\VIRSH_GPU_SBC=pci_0000_01_00_3' /etc/libvirt/hooks/kvm.conf

sudo sed -i '81s/.//' /etc/libvirt/libvirtd.conf
sudo sed -i '104s/.//' /etc/libvirt/libvirtd.conf
sudo sed -i '$ a\log_filters="1:qemu"' /etc/libvirt/libvirtd.conf
sudo sed -i '$ a\log_outputs="1:file:/var/log/libvirt/libvirtd.log"' /etc/libvirt/libvirtd.conf

sudo usermod -a -G libvirt $(whoami)

sudo sed -i '/#user = "libvirt-qemu"/c \user = "ivo"' /etc/libvirt/qemu.conf
sudo sed -i '/#group = "libvirt-qemu"/c \group = "wheel"' /etc/libvirt/qemu.conf

sudo mkdir -p /var/lib/libvirt/vbios
#sudo tar -C /var/lib/libvirt/vbios -xzvf gpu.tar.gz
rm gpu.tar.gz
#sudo chmod 644 /var/lib/libvirt/vbios/gpu.rom

#-----------------------------------SAMBA-----------------------------------------

sudo tar -C /etc/samba/ -xzvf smb.tar.gz
rm smb.tar.gz

#-----------------------------------SUDOERS---------------------------------------

sudo sed -i '$ a\ivo    ALL=(ALL)    NOPASSWD: /usr/bin/virsh' /etc/sudoers
sudo sed -i '$ a\ivo    ALL=(ALL)    NOPASSWD: /usr/bin/nvidia-persistenced' /etc/sudoers
sudo sed -i '$ a\ivo    ALL=(ALL)    NOPASSWD: /usr/bin/nvidia-smi' /etc/sudoers

# ---------------------------------SERVICES---------------------------------------

sudo systemctl enable teamviewerd
echo "  teamviewerd enabled"
sudo systemctl enable --now ckb-next-daemon
echo "  iCue enabled and started"
sudo systemctl enable --now libvirtd.service
echo "  libvirtd enabled and started"
sudo systemctl enable --now virtlogd.socket
echo "  virtlogd enabled and started"
sudo virsh net-autostart default
echo "  net-autostart enabled"
sudo virsh net-start default
echo "  net-start enabled"

# ---------------------------------FIREWALL---------------------------------------

sudo systemctl enable ufw.service --now
echo "  firewall enabled and started"
sudo ufw default deny
sudo ufw enable
sudo ufw allow from 192.168.0.0/24
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
sudo ufw reload

# ---------------------------------THEME---------------------------------------

tar -xzvf Dragon.tar.gz
sudo mv Dragon /usr/share/sddm/themes/

tar -C /home/ivo/ -xzvf config.tar.gz
rm config.tar.gz
tar -C /home/ivo/ -xzvf icons.tar.gz
rm icons.tar.gz
tar -C /home/ivo/ -xzvf local.tar.gz

rm local.tar.gz
rm Dragon.tar.gz
rm Omen.tar.gz

# ---------------------------------FSTAB---------------------------------------

sudo sed -i '$ a # \t\t nvme1n1p3 - Games SSD' /etc/fstab
sudo sed -i '$ a #UUID=26d327c5-d5a7-4e39-a782-b9374951e0ee\t/media/btrfs/ssd\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a #HDD' /etc/fstab
sudo sed -i '$ a # \t\t sdc1 - NEXTCLOUD' /etc/fstab
sudo sed -i '$ a UUID=f4b349cb7-6aad-44a8-b1d5-105b4bcfd29d\t/media/btrfs/nc\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t sdc3 - HDD' /etc/fstab
sudo sed -i '$ a UUID=130efac5-8fbe-4a27-80f8-97be0158e5a0\t/media/btrfs/hdd\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t sdc2 - BACKUPS' /etc/fstab
sudo sed -i '$ a UUID=3530600d-1f05-422a-8372-87ae1d0c5e27\t/media/btrfs/bkp\btrfs\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a #WINDOWS' /etc/fstab
sudo sed -i '$ a # \t\t sda3 - Windows 10' /etc/fstab
sudo sed -i '$ a UUID=08E2109DE21090D4\t/media/ntfs/w-sys\ntfs-3g\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t sda4 - Windows SSD' /etc/fstab
sudo sed -i '$ a UUID=26F6AD3E032C2534\t/media/ntfs/w-ssd\ntfs-3g\tdefaults,rw,relatime\t0\t0' /etc/fstab

sudo sed -i '$ a # \t\t sdb1 - Samsung' /etc/fstab
sudo sed -i '$ a UUID=03B140B373965BED\t/media/ntfs/evo\ntfs-3g\tdefaults,rw,relatime\t0\t0' /etc/fstab

# ---------------------------------REBOOT---------------------------------------

echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
