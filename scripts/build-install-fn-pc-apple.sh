#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq git python-is-python3 build-essential cmake libexpat-dev libmbedtls-dev python3-jinja2 python3-yaml

FN_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
INSTALL_PATH="$FN_PATH/FujiNet-PC-Apple"
mkdir -p "$INSTALL_PATH"
cd "$FN_PATH"

git clone https://github.com/FujiNetWIFI/fujinet-platformio

FNPIO_PATH="$FN_PATH/fujinet-platformio"
mkdir -p "$FNPIO_PATH/build"
cd "$FNPIO_PATH" 

./build.sh -cp APPLE

rsync -au "$FNPIO_PATH/build/dist/" "$INSTALL_PATH/"

cat <<EOF | sudo tee /etc/systemd/system/fn-pc-apple.service 
[Unit]
Description=FujiNet PC for Apple
After=remote-fs.target
After=syslog.target

[Service]
WorkingDirectory=$INSTALL_PATH
User=$P_USERNAME
Group=$P_USERNAME
ExecStart=$INSTALL_PATH/run-fujinet
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable fn-pc-apple.service