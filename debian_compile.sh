#!/bin/bash

VERSION="1.0.X200"
GIT_BRANCH="master" # See more here -> http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/
KERNEL_FOLDER_GIT="linux-git"
CORES="2"


git clone -b $GIT_BRANCH git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable.git $KERNEL_FOLDER
echo "Enter kernel source folder..."
cd $KERNEL_FOLDER
echo "Copy current kernel config..."
sudo cp /boot/config-$(uname -r) .config
echo "Make Menuconfig..."
make menuconfig
echo "Cleaning source folder..."
make-kpkg clean
echo "Building kernel..."
fakeroot make-kpkg --initrd --revision=$VERSION kernel_image kernel_headers -j $CORES
echo "Done."
