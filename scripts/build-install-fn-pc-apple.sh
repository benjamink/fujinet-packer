#!/usr/bin/env bash
set -x

sudo apt install -y python-is-python3 build-essential cmake libexpat-dev libmbedtls-dev python3-jinja2 python3-yaml

FN_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
INSTALL_PATH="$CODE_PATH/FujiNet-PC-Apple"
mkdir -p "$FN_PATH"
cd "$FN_PATH"

git clone https://github.com/FujiNetWIFI/fujinet-platformio

FNPIO_PATH="$FN_PATH/fujinet-platformio"
cd "$FNPIO_PATH" 

./build.sh -cp APPLE

mkdir -p "$INSTALL_PATH"
cp -r "$FN_PATH/build/*" "$INSTALL_PATH/"

cat <<EOF | sudo tee /etc/system/systemd/fn-pc-atari.service 
[Unit]
Description=FujiNet PC for Apple
After=remote-fs.target
After=syslog.target

[Service]
WorkingDirectory=$INSTALL_PATH
User=vcf
Group=vcf
ExecStart=$INSTALL_PATH/run-fujinet

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload