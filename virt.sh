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
sudo sed -i '81s/.//' /etc/libvirt/libvirtd.conf
sudo sed -i '104s/.//' /etc/libvirt/libvirtd.conf

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
sleep 5
reboot
