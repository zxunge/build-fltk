#!/usr/bin/bash

set -eux

FLTK_VERSION=1.3.9
NAME=FLTK-${FLTK_VERSION}
HOME=$(cygpath -m /home)
BUILD_NO=2
BUILD_INFO="--enable-threads --enable-debug"

# Install dependencies
pacman -Syy
pacman -S --noconfirm  wget mingw-w64-i686-toolchain p7zip

# Building at /home for convenience
cp -r * /home/
cd /home

wget https://www.fltk.org/pub/fltk/${FLTK_VERSION}/fltk-${FLTK_VERSION}-source.tar.bz2
tar -jxf fltk-${FLTK_VERSION}-source.tar.bz2
cd fltk-${FLTK_VERSION}

./configure --prefix=/home/FLTK ${BUILD_INFO}
mingw32-make

7zr a -mx9 -mqs=on -mmt=on /home/${NAME}.7z /home/FLTK

if [[ -v GITHUB_WORKFLOW ]]; then
  echo "OUTPUT_BINARY=${HOME}/${NAME}.7z" >> $GITHUB_OUTPUT
  echo "RELEASE_NAME=fltk-${FLTK_VERSION}" >> $GITHUB_OUTPUT
  echo "FLTK_VERSION=${FLTK_VERSION}" >> $GITHUB_OUTPUT
  echo "OUTPUT_NAME=${NAME}.7z" >> $GITHUB_OUTPUT
  echo "BUILD_INFO=${BUILD_INFO}" >> $GITHUB_OUTPUT
fi
