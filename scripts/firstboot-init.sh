#!/usr/bin/env bash
set -x 

# Script to run at first boot
cat <<EOF | sudo tee /usr/local/sbin/firstboot-setup.sh
#!/usr/bin/env bash 
set -x

ntpdate ntp.ubuntu.com

PRIMARY_IF="\$(ls /sys/class/net | grep -v "lo")"

sed -i "s/allow-hotplug .*/allow-hotplug \${PRIMARY_IF}/" /etc/network/interfaces
sed -i "s/.* inet dhcp/iface \${PRIMARY_IF} inet dhcp/" /etc/network/interfaces
systemctl restart networking
systemctl disable firstboot.service

su -c $P_USERNAME {
  xfconf-query --create -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/last-image -t string -s "/home/$P_USERNAME/Pictures/wallpaper.png"
  xfconf-query --create -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/rgba1 -t float -t float -t float -t float -s 0.141176 -s 0.121569 -s 0.192157 -s 1.000000
  xfconf-query --create -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/rgba2 -t float -t float -t float -t float -s 0.466667 -s 0.462745 -s 0.482353 -s 1.000000
  xfconf-query --create -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/color-style -t int -s 2
  xfconf-query --create -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/image-style -t int -s 4
  xfconf-query --create -c xfce4-desktop -p /backdrop/single-workspace-mode -t bool -s true
  xfconf-query --create -c xfce4-desktop -p /backdrop/single-workspace-number -t int -s 0
}
EOF

sudo chmod +x /usr/local/sbin/firstboot-setup.sh

# Setup the systemd to run firstboot
cat <<EOF | sudo tee /etc/systemd/system/firstboot.service
[Unit]
Description=Initial system setup

[Service]
Type=simple
ExecStart=/usr/local/sbin/firstboot-setup.sh 

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload 
systemctl enable firstboot.service