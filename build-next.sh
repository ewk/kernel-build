#!/bin/bash

#
# Fetch and build latest linux-next.
#

set -e

configdir="$HOME"/Documents/hacks/kernel/build

#
# Update the local git tree
#

# Fetch the latest linux-next
cd "$HOME"/Projects/src/linux
git checkout master
# remove dead branches
git remote update --prune
# Fast-forward merge should always work if you don't develop on master!
# Don't ever 'git pull' linux-next.
# @{u} is a shortcut to the upstream branch the current branch is tracking.
git merge --ff-only '@{u}'
# Checkout the latest linux-next tag
next="$(git tag | grep next | sort --version-sort | tail -1)"
git checkout "$next"

#
# Clean up build and install directories
#

# remove old builds
sudo rm -r /lib/modules/*next* || true
sudo rm /boot/*next* || true
sudo rm /boot/System.map || true
sudo rm /boot/vmlinuz || true

# Now we are ready to build
make mrproper
cp "$configdir"/config .config
make oldconfig

# save the updated config
cp .config "$configdir"/config

# This part will take a bit
time make -j"$(nproc)" --silent 2> log

source "$HOME"/Documents/hacks/kernel/build/install-next.sh
