#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq xfce4 xfce4-terminal lightdm-autologin-greeter
sudo cp /tmp/wallpaper.png /etc/lightdm/login-logo.png 
sudo cp /tmp/login-icon.png /etc/lightdm/login-icon.png
sudo chown root:root /etc/lightdm/*.png
sudo chmod 644 /etc/lightdm/*.png

cat <<EOF | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf
[greeter]
background = /etc/lightdm/login-logo.png
theme-name = Adwaita-dark 
background-color = #143352 
position = 83%,center
icon-theme-name = Adwaita 
font-name = Sans 8 
default-user-image = /etc/lightdm/login-icon.png
EOF

sudo sed -i 's/^#autologin-user=/autologin-user=fujinet/;s/^#autologin-user-timeout=0/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf