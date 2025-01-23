#!/usr/bin/env bash
set -x

ln -s "/home/$P_USERNAME/.local/bin/upgrade_vm" "/home/$P_USERNAME/upgrade_vm"

LAUNCHER_PATH="$DESKTOP/UpgradeVM.desktop"
cat <<EOF > "$LAUNCHER_PATH"
[Desktop Entry]
Version=1.0
Type=Application
Name=Upgrade VM 
Comment=Upgrade VM OS & components
Exec=/home/$P_USERNAME/.local/bin/upgrade_vm -a
Icon=go-up 
Path=
Terminal=true 
StartupNotify=false
EOF

chmod +x "$LAUNCHER_PATH"
gio set -t string "$LAUNCHER_PATH" metadata::xfce-exe-checksum "$(sha256sum "$LAUNCHER_PATH" | awk '{print $1}')"