#!/usr/bin/env bash
set -x

sudo apt install -y xfce4
sudo cp /tmp/wallpaper.png /etc/lightdm/login-logo.png 

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