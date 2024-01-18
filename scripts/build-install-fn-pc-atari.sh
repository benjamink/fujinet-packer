#!/usr/bin/env bash
set -x

sudo apt install -y python-is-python3 build-essential cmake libexpat-dev libmbedtls-dev python3-jinja2 python3-yaml 

CODE_PATH="${P_CODE_PATH:-/home/$P_USERNAME/code}"
mkdir -p "$CODE_PATH"
cd "$CODE_PATH"

git clone "$P_FUJINET_PLATFORMIO_URL"

cd "$CODE_PATH/fujinet-platformio"

./build.sh -cp ATARI
