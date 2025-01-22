#!/usr/bin/env bash 
set -x 

LAUNCHER_PATH="/home/$P_USERNAME/Desktop/CoCoMAME.desktop"
CODE_PATH="${P_FN_PATH}/CoCoMAME"
mkdir -p "$CODE_PATH" 
cd "$CODE_PATH" || exit
tar -zxvf /tmp/cocomame.tar.gz && rm /tmp/cocomame.tar.gz

cat <<EOF > "$LAUNCHER_PATH"
[Desktop Entry]
Encoding=UTF-8
Name=FujiNet CoCo MAME
Comment=FujiNet connected to CoCo MAME
Type=Application
Exec=$CODE_PATH/cocomame coco2b -window -ext fdc,bios=hdbk3 -skip_gameinfo
Path=$CODE_PATH
Icon=org.Xfce.settings.color
EOF

chmod +x "$LAUNCHER_PATH"
gio set -t string "$LAUNCHER_PATH" metadata::xfce-exe-checksum "$(sha256sum "$LAUNCHER_PATH" | awk '{print $1}')"

cat <<EOF > "$WEB_URL_PATH"
[Desktop Entry]
Version=1.0
Name=FujiNet CoCo Web UI
Comment=Web UI admin console for FujiNet CoCo
Type=Link
Icon=/home/$P_USERNAME/Pictures/fn-logo-black.png
URL=http://localhost:8002
EOF

chmod +x "$WEB_URL_PATH"
gio set -t string "$WEB_URL_PATH" metadata::xfce-exe-checksum "$(sha256sum "$WEB_URL_PATH" | awk '{print $1}')"