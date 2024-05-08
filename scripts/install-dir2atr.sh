#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq git build-essential cmake

CODE_PATH="${P_FN_PATH}/AtariSIO"
git clone "https://github.com/HiassofT/AtariSIO.git" "$CODE_PATH"
cd "${CODE_PATH}/tools" || exit

make -f Makefile.posix 
sudo make -f Makefile.posix install 

