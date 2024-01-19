#!/usr/bin/env bash
set -x 

cat <<EOF | sudo tee /usr/local/sbin/firstboot-setup.sh
#!/usr/bin/env bash 
set -x

ntpdate ntp.ubuntu.com

PRIMARY_IF="$(ls /sys/class/net | grep -v "lo")"

sed "s/allow-hotplug .*/allow-hotplug \${PRIMARY_IF}/" /etc/network/interfaces
sed "s/.* inet dhcp/iface \${PRIMARY_IF} inet dhcp/" /etc/network/interfaces
systemctl restart network
systemctl disable firstboot.service
EOF

sudo chmod +x /usr/local/sbin/firstboot-setup.sh

cat <<EOD | sudo tee /etc/systemd/system/firstboot.service
[Unit]
Description=Initial system setup

[Service]
Type=simple
ExecStart=/usr/local/sbin/firstboot-setup.sh 

[Install]
WantedBy=multi-user.target
EOD 

systemctl daemon-reload 
systemctl enable firstboot.service