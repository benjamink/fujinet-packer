#!/usr/bin/env bash
set -x

INSTALL_PATH="/home/$P_USERNAME/FujiNet"

# Download 
curl -sLo /tmp/fujinet-pc.zip "$P_FUJINET_PC_ZIP_URL"

# Install
mkdir -p "$INSTALL_PATH"
cd "$INSTALL_PATH"
unzip /tmp/fujinet-pc.zip
rm -f /tmp/fujinet-pc.zip 
