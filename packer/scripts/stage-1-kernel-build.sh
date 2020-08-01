#!/bin/bash

set -x

# Download source
curl https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.7.12.tar.xz -o linux-5.7.12.tar.xz

# Unpack source
unxz -v linux-5.7.12.tar.xz

# verify and extract tarball
curl https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.7.12.tar.sign -o linux-5.7.12.tar.sign 
RSA_KEY=$(gpg --verify linux-5.7.12.tar.sign 2>&1 | grep "RSA key ID" | sed -r 's/.* (\w+)$/\1/')
gpg --recv-keys $RSA_KEY
gpg --verify linux-5.7.12.tar.sign
tar xvf linux-5.7.12.tar && rm linux-5.7.12.tar

cd linux-5.7.12

# Install the required compilers and other tools
yum group install -y "Development Tools"
yum install -y ncurses-devel bison flex elfutils-libelf-devel openssl-devel bc

# Configure the Linux kernel features and modules
make olddefconfig

# compile a Linux Kernel
make -j $(nproc)

# install kernel modules and kernel
make modules_install
make install

# update grub
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
echo "Grub update done."

# reboot
shutdown -r 0
