#!/usr/bin/env bash
set -x

sudo apt install -y wine

WINEPREFIX="/home/$P_USERNAME/Wine"

mkdir -p "$WINEPREFIX"

unset DISPLAY
wine hostname