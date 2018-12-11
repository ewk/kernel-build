#!/bin/bash

# Prepare kernel source before building a module.
# Assumes you have already checked out the branch you want to work with.
# Mostly useful for building drivers out of tree.

cd $HOME/Projects/src/linux
# or make defconfig
cp $HOME/Documents/hacks/kernel/build/config /home/ewk/Projects/src/linux/.config
make prepare
make modules_prepare
