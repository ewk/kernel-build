#!/bin/bash

set -e

# $builddir from build script
cd /tmp/rc

# First copy modules to /lib/modules/
sudo make modules_install

# On most distributions you can just run:
#sudo make install

# Arch uses mkinitcpio to create the initial ramdisk, which requires
# a few extra steps to finish installing the new kernel.
release="$(make kernelrelease)"

# Move the new kernel image and system map into place.
sudo cp -v /tmp/rc/arch/x86/boot/bzImage /boot/vmlinuz-"$release"
sudo cp -v /tmp/rc/System.map /boot/System.map-"$release"

# Make a new initramfs image file using /etc/mkinitcpio.conf
sudo mkinitcpio -k "$release" -g /boot/initramfs-"$release".img

# Update systemd-boot entry
loader=/boot/loader/entries/linux-next.conf
sudo sed -i "s/vmlinuz-.*next.*/vmlinuz-$release/" "$loader"
sudo sed -i "s/initramfs.*next.*\.img/initramfs-$release\.img/" "$loader"
sudo cat "$loader"
