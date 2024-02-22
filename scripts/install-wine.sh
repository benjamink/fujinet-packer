#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq wine

sudo mkdir /usr/share/wine/gecko
sudo curl -o /usr/share/wine/gecko/wine-gecko-2.47.3-x86_64.msi "https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86_64.msi" 

WINEPREFIX="/home/$P_USERNAME/Wine"

mkdir -p "$WINEPREFIX"

unset DISPLAY
wine hostname