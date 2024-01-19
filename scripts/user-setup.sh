#!/usr/bin/env bash
set -x

mkdir "/home/$P_USERNAME/Desktop"
mkdir "/home/$P_USERNAME/Pictures"
mkdir "/home/$P_USERNAME/Downloads"
mkdir "/home/$P_USERNAME/Documents"

cp /tmp/wallpaper.png "/home/$P_USERNAME/Pictures/wallpaper.png"

xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/last-image -t string -s "/home/$USER/Pictures/wallpaper.png"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/rgba1 -t float -t float -t float -t float -s 0.141176 -s 0.121569 -s 0.192157 -s 1.000000
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/rgba2 -t float -t float -t float -t float -s 0.466667 -s 0.462745 -s 0.482353 -s 1.000000
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/color-style -t int -s 2
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/image-style -t int -s 4
xfconf-query -c xfce4-desktop -p /backdrop/single-workspace-mode -t bool -s true
xfconf-query -c xfce4-desktop -p /backdrop/single-workspace-number -t int -s 0