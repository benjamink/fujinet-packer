#!/usr/bin/env bash
set -x

sudo apt install -y build-essential curl cc65 default-jre

CODE_PATH="${P_CODE_PATH:-/home/$P_USERNAME/code}"
mkdir -p "$CODE_PATH"
cd "$CODE_PATH" 

git clone "$P_FUJINET_APPS_URL"