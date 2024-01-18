#!/usr/bin/env bash
set -x

sudo apt install -y python-is-python3 build-essential cmake libexpat-dev libmbedtls-dev python3-jinja2 python3-yaml

INSTALL_PATH="/home/$P_USERNAME/FujiNet/FujiNet-PC-Apple"
CODE_PATH="${P_CODE_PATH:-/home/$P_USERNAME/home}"
mkdir -p "$CODE_PATH"
cd "$CODE_PATH"

git clone "$P_FUJINET_PLATFORMIO_URL"

cd "$CODE_PATH/fujinet-platformio"

./build.sh -cp APPLE

mkdir -p "$INSTALL_PATH"
cp -r "$CODE_PATH/build/*" "$INSTALL_PATH/"

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