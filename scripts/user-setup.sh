#!/usr/bin/env bash
set -x

mkdir "/home/$P_USERNAME/Desktop"
mkdir "/home/$P_USERNAME/Pictures"
mkdir "/home/$P_USERNAME/Downloads"
mkdir "/home/$P_USERNAME/Documents"

cp /tmp/wallpaper.png "/home/$P_USERNAME/Pictures/wallpaper.png"

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