#!/bin/bash

set -e

export tmp="/vagrant"

echo "Installing packages for pxe server"
apt-get update
apt-get install -fy dnsmasq apache2-mpm-prefork iptables-persistent apt-cacher-ng

#Location for all pxe files
mkdir -p /srv/tftpboot

if [[ ! -f /srv/tftpboot/grubnetx64.efi.signed ]]; then
 echo "Downloading grub efi signed pxe boot image"
 wget -O /srv/tftpboot/grubnetx64.efi.signed http://archive.ubuntu.com/ubuntu/dists/xenial/main/uefi/grub2-amd64/current/grubnetx64.efi.signed >/dev/null 2>&1
fi
if [[ ! -f /srv/tftpboot/netboot.tar.gz ]]; then
 echo "Downloading netboot tarball"
 wget -O /srv/tftpboot/netboot.tar.gz http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/current/images/netboot/netboot.tar.gz
fi

#Unzip netboot
cd /srv/tftpboot
tar xzf netboot.tar.gz

#Setup grub with preseed
[[ ! -d /srv/tftpboot/grub ]] && mkdir -p /srv/tftpboot/grub
cp -f $tmp/files/grub-network.cfg /srv/tftpboot/grub/

#Setup non-grub install
cp -f $tmp/files/txt-network.cfg /srv/tftpboot/ubuntu-installer/amd64/boot-screens/txt.cfg

#Copy preseed and scripts to html
cp -f $tmp/files/secure-desktop.seed /tmp/secure-desktop.seed
echo "Updating late_command for preseed"
$tmp/scripts/setup_preseed_command.sh >> /tmp/secure-desktop.seed
cp /tmp/secure-desktop.seed /var/www/html/secure-desktop-nvme0.seed
cp /tmp/secure-desktop.seed /var/www/html/secure-desktop-sda.seed
cp /tmp/secure-desktop.seed /var/www/html/secure-desktop-sdb.seed

grep -v 'DISK' /tmp/secure-desktop.seed > /var/www/html/secure-desktop.seed
sed -i 's/DISK/nvme0n1/' /var/www/html/secure-desktop-nvme0.seed
sed -i 's/DISK/sda/' /var/www/html/secure-desktop-sda.seed
sed -i 's/DISK/sdb/' /var/www/html/secure-desktop-sdb.seed

# Copy first boot scripts
cp -rp $tmp/files/firstboot_scripts /var/www/html/

chown -R www-data:www-data /var/www/html

#Configure dnsmasq
cp -f $tmp/files/dnsmasq.conf /etc/

#Setup machine to be the router 
echo "Setup ip forwarding and Masquerading"
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p > /dev/null
/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables-save > /etc/iptables/rules.v4

service dnsmasq restart
service apache2 restart
service apt-cacher-ng restart 
