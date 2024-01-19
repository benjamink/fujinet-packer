#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq wine

WINEPREFIX="/home/$P_USERNAME/Wine"

mkdir -p "$WINEPREFIX"

unset DISPLAY
wine hostname