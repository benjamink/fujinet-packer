#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq xfce4 xfce4-terminal
sudo cp /tmp/wallpaper.png /etc/lightdm/login-logo.png 
sudo chown root:root /etc/lightdm/*.png
sudo chmod 644 /etc/lightdm/*.png

cat <<EOF | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf
[greeter]
background = /etc/lightdm/login-logo.png
theme-name = Adwaita-dark 
background-color = #143352 
position = 50%,center 37%,center
icon-theme-name = Adwaita 
font-name = Sans 8 
hide-user-image = true
EOF