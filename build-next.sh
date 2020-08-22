#!/bin/bash

#
# Fetch and build latest linux-next.
# Will fail if there's no 'next' for today's date.
#

set -e

builddir=/tmp/rc
configdir="$HOME"/Documents/hacks/kernel/build
log="$builddir"/log

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
git merge --ff-only @{u}
# This does not work on weekends.
git checkout next-"$(date '+%Y%m%d')"

#
# Clean up build and install directories
#

# remove old builds
sudo rm -r /lib/modules/*next* || true
sudo rm /boot/*next* || true
sudo rm -r "$builddir" || true

# Now we are ready to build
mkdir "$builddir"
cp "$configdir"/config .config
make oldconfig

# save the updated config
cp .config "$configdir"/config

# Prepare to start the build
mv .config "$builddir"/.config
# remove generated files and the config
make mrproper

# This part will take a bit
echo ""
echo "Build in progress. Time to take a break."
echo "Logging to $log"
echo ""
time make -j8 O="$builddir" 2>&1 | tee "$log"

source "$HOME"/Documents/hacks/kernel/build/install-next.sh
