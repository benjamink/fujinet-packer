#!/usr/bin/env bash
set -x

# Install Samba
sudo apt-get install -y -qq samba samba-common-bin

# Configure tnfs user & add Packer user to tnfs group
sudo useradd -c 'tnfsd user' -U -m -d /tnfs -r tnfs 
sudo usermod -a -G tnfs "$P_USERNAME"

# Install tnfsd
sudo curl -sLo /usr/local/sbin/tnfsd "https://fujinet.online/firmware/tnfsd.linux64"
sudo chmod +x /usr/local/sbin/tnfsd 

# Populate Samba tnfs share config
cat <<EOF | sudo tee -a /etc/samba/smb.conf
[tnfs]
  path = /tnfs
  writeable = Yes
  create mask = 0777
  directory mask = 0777
  public = yes
  force user = tnfs
  force group = tnfs
EOF

# Configure tnfsd systemd init
cat <<EOF | sudo tee /etc/systemd/system/tnfsd.service
[Unit]
Description=TNFS Server
After=remote-fs.target
After=syslog.target

[Service]
User=tnfs
Group=tnfs
ExecStart=/usr/local/sbin/tnfsd /tnfs

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload 
sudo systemctl enable tnfsd 
sudo systemctl start tnfsd