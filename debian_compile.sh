#!/bin/bash

VERSION="1.0.CLANG"

DIR="linux-stable"
if [ -d "$DIR" ]; then
  echo "Updateing branch..."
  cd $DIR
  git reset --hard
  make clean
  git pull
else
  echo "Clone branch..."
  git clone -b master git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/
fi

echo "Enter kernel source folder..."
cd linux-stable

echo "Copy current kernel config..."
sudo cp /boot/config-$(uname -r) .config

#echo "Get current gcc patch..."
#cp ../enable_additional_cpu_optimizations_for_gcc_v4.9+_kernel_v4.13+.patch .
#patch -p1 < enable_additional_cpu_optimizations_for_gcc_v4.9+_kernel_v4.13+.patch

echo "Make Old&Menuconfig..."
make oldconfig
#make menuconfig

echo "Cleaning source folder..."
make clean

echo "Building kernel..."
make CC=clang LLVM=1 -j$(nproc) bindeb-pkg

echo "Done. You'll find the debian packages in this directory."
