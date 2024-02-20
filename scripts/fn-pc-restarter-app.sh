#!/usr/bin/env bash
set -x

sudo apt-get install -y cmake python3-pkgconfig dbus-1-dev libglib2.0-dev 

FN_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
INSTALL_PATH="$FN_PATH/FujiNet-PC-Restarter"
mkdir -p "$INSTALL_PATH"
cd "$FN_PATH"


