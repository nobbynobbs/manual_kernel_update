#!/bin/bash

set -x

# Install Guest additions
mkdir /media/iso_guest_additions
mount -o loop /home/vagrant/VBoxGuestAdditions.iso /media/iso_guest_additions
/media/iso_guest_additions/VBoxLinuxAdditions.run


# Uninstall compilers and other tools
yum groupremove -y "Development Tools"
yum remove -y kernel-devel ncurses-devel bison flex elfutils-libelf-devel openssl-devel bc


# clean all caches
yum update -y
yum clean all


# Install vagrant default key
mkdir -pm 700 /home/vagrant/.ssh
curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh


# Remove temporary files
rm -rf /tmp/*
rm  -f /var/log/wtmp /var/log/btmp
rm -rf /var/cache/* /usr/share/doc/*
rm -rf /var/cache/yum
rm -rf /home/vagrant/*.iso
rm  -f ~/.bash_history
rm -rf /home/vagrant/linux*
history -c

rm -rf /run/log/journal/*

# Fill zeros all empty space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync
grub2-set-default 1
echo "###   Hi from second stage" >> /boot/grub2/grub.cfg
