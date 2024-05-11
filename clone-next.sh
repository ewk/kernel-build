#!/bin/bash

#
# Clone linux-next on top of Linus' tree
#

set -e

mkdir -p "$HOME"/Projects/src
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git "$HOME"/Projects/src/linux
cd "$HOME"/Projects/src/linux
git remote add linux-next git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
git fetch linux-next
git fetch --tags linux-next
