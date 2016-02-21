#!/bin/bash

VERSION="1.0.X200"
CORES="2"


echo "Clone branch..."
mkdir $KERNEL_FOLDER
git clone -b master git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/
echo "Enter kernel source folder..."
cd linux-stable
echo "Copy current kernel config..."
sudo cp /boot/config-$(uname -r) .config
echo "Make Menuconfig..."
make menuconfig
echo "Cleaning source folder..."
make-kpkg clean
echo "Building kernel..."
fakeroot make-kpkg --initrd --revision=$VERSION kernel_image kernel_headers -j $CORES
echo "Done."
