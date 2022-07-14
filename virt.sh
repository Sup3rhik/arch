#!/usr/bin/env bash
#-------------------------------------------------------------------------

sudo pacman -Syu --noconfirm

echo
echo "INSTALLING SOFTWARE"
echo

PKGS=(

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

)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo

#-------------------------------------------------------------------------
tar -xzvf hooks.tar.gz
sudo mkdir -p /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
sudo mkdir -p /etc/libvirt/hooks/qemu.d/Windows/prepare/begin
sudo mkdir -p /etc/libvirt/hooks/qemu.d/Windows/release/end

sudo cp start.sh /etc/libvirt/hooks/qemu.d/Windows/prepare/begin/
sudo chmod +x /etc/libvirt/hooks/qemu.d/Windows/prepare/begin/start.sh

sudo cp revert.sh /etc/libvirt/hooks/qemu.d/Windows/release/end/
sudo chmod +x /etc/libvirt/hooks/qemu.d/Windows/release/end/revert.sh

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

sed -i '/#user = "libvirt-qemu"/c \user = "ivo"' /etc/libvirt/qemu.conf
sed -i '/#group = "libvirt-qemu"/c \group = "wheel"' /etc/libvirt/qemu.conf
sudo mkdir -p /var/lib/libvirt/vbios

#-------------------------------------------------------------------------

echo
echo "FINAL SETUP AND CONFIGURATION"

sudo usermod -a -G libvirt $(whoami)
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

# ------------------------------------------------------------------------

echo
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
#sleep 5
#reboot
