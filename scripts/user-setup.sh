#!/usr/bin/env bash
set -x

sudo apt-get install -y epiphany-browser 

mkdir "/home/$P_USERNAME/Desktop"
mkdir "/home/$P_USERNAME/Pictures"
mkdir "/home/$P_USERNAME/Downloads"
mkdir "/home/$P_USERNAME/Documents"
mkdir -p "${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"

cp /tmp/wallpaper.png "/home/$P_USERNAME/Pictures/wallpaper.png"
cp /tmp/fn-logo-black.png "/home/$P_USERNAME/Pictures/fn-logo-black.png"

cat <<EOF | sudo tee /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml 
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitorVirtual1" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="1"/>
          <property name="image-style" type="int" value="4"/>
          <property name="last-image" type="string" value="/home/$P_USERNAME/Pictures/wallpaper.png"/>
          <property name="rgba1" type="array">
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="1"/>
          </property
          <property name="rgba2" type="array">
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="0"/>
            <value type="double" value="1"/>
          </property
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

cat <<EOF | sudo tee /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml 
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="workspace_count" type="int" value="1"/>
  </property>
</channel>
EOF

#cat <<EOF >> "/home/$P_USERNAME/.bashrc"
#
## Disable screensaver
#export DISPLAY=:0.0
#xset s off
#xset s noblank
#xset -dpms
#EOF