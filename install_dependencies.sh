#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!"
   exit 1
fi

echo "Fetching updates..."
apt-get update
echo "Installing dependencies for kernel compilation..."
apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc kernel-package libelf-dev lsb-release wget software-properties-common

echo "Download & Install latest LLVM Toolchain"

################################################################################
# Useing parts of the LLVM Toolchain Install Script from the LLVM Project,
# it's under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
################################################################################

set -eux

DISTRO=$(lsb_release -is)
VERSION=$(lsb_release -sr)
DIST_VERSION="${DISTRO}_${VERSION}"

# find the right repository name for the distro and version
case "$DIST_VERSION" in
    Debian_9* )       REPO_NAME="deb http://apt.llvm.org/stretch/  llvm-toolchain-stretch main" ;;
    Debian_10* )      REPO_NAME="deb http://apt.llvm.org/buster/   llvm-toolchain-buster  main" ;;
    Debian_11* )      REPO_NAME="deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye  main" ;;
    Debian_unstable ) REPO_NAME="deb http://apt.llvm.org/unstable/ llvm-toolchain         main" ;;
    Debian_testing )  REPO_NAME="deb http://apt.llvm.org/unstable/ llvm-toolchain         main" ;;
    Ubuntu_16.04 )    REPO_NAME="deb http://apt.llvm.org/xenial/   llvm-toolchain-xenial  main" ;;
    Ubuntu_18.04 )    REPO_NAME="deb http://apt.llvm.org/bionic/   llvm-toolchain-bionic  main" ;;
    Ubuntu_18.10 )    REPO_NAME="deb http://apt.llvm.org/cosmic/   llvm-toolchain-cosmic  main" ;;
    Ubuntu_19.04 )    REPO_NAME="deb http://apt.llvm.org/disco/    llvm-toolchain-disco   main" ;;
    Ubuntu_19.10 )   REPO_NAME="deb http://apt.llvm.org/eoan/      llvm-toolchain-eoan    main" ;;
    Ubuntu_20.04 )   REPO_NAME="deb http://apt.llvm.org/focal/     llvm-toolchain-focal   main" ;;
    Ubuntu_21.04 )   REPO_NAME="deb http://apt.llvm.org/groovy/    llvm-toolchain-groovy  main" ;;
    Ubuntu_21.10 )   REPO_NAME="deb http://apt.llvm.org/hirsute/   llvm-toolchain-hirsute main" ;;
    * )
        echo "Distribution '$DISTRO' in version '$VERSION' is not supported by this script (${DIST_VERSION})."
        exit 2
esac

# install llvm-toolchain
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
add-apt-repository "${REPO_NAME}"
apt-get update
apt-get install -y clang lldb lld clangd
