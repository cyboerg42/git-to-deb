#!/bin/bash

echo "Fetching updates..."
sudo apt-get update
echo "Installing dependencies for kernel compilation..."
sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc kernel-package
