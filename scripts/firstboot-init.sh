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