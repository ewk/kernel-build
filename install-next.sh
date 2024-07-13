#!/bin/bash

tasks="$(nproc)"

# $builddir from build script
cd /tmp/rc

# First copy modules to /lib/modules/
sudo make -j"$tasks" modules_install

if [[ -e "/etc/arch-release" ]]
then
	# Arch uses mkinitcpio to create the initial ramdisk, which requires
	# a few extra steps to finish installing the new kernel.
	release="$(make kernelrelease)"

	# Move the new kernel image and system map into place.
	sudo cp --verbose /tmp/rc/arch/x86/boot/bzImage /boot/vmlinuz-"$release"
	sudo cp --verbose /tmp/rc/System.map /boot/System.map-"$release"

	# Make a new initramfs image file using /etc/mkinitcpio.conf
	sudo mkinitcpio --kernel "$release" --generate /boot/initramfs-"$release".img

	sudo grub-mkconfig -o /boot/grub/grub.cfg
elif [[ -e "/etc/fedora-release" ]]
then
	old_entry="$(sudo grubby --info=ALL | rg '^kernel="(/boot/vmlinuz.*next.*)"' -r '$1')"
	sudo grubby --remove-kernel="$old_entry" || true
	sudo make install
else
	echo "Unable to identify distro"
fi
