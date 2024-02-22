#!/usr/bin/env bash
set -x

MENU_ROOT_PATH="/home/$P_USERNAME/.config/menus"
APPS_ROOT_PATH="/home/$P_USERNAME/.local/share/applications"
mkdir -p "$MENU_ROOT_PATH"
mkdir -p "$APPS_ROOT_PATH"

cp /etc/xdg/menus/xfce-applications.menu "$MENU_ROOT_PATH"
sed -i 's/Other/FujiNet/;s/xfce-other/xfce-fujinet/' "$MENU_ROOT_PATH/xfce-applications.menu"

FN_WIKI_ICON_PATH="/home/$P_USERNAME/.local/share/applications/FujiNet-Wiki-URL.desktop"
VM_HELP_ICON_PATH="/home/$P_USERNAME/.local/share/applications/FujiNet-VM-Help-URL.desktop"
APPLEWIN_HELP_ICON_PATH="/home/$P_USERNAME/.local/share/applications/AppleWin-Help-URL.desktop"

cat <<EOF | tee "$VM_HELP_ICON_PATH"
[Desktop Entry]
Version=1.0
Type=Link
Name=FujiNet VM Help
Comment=Help for using this VM
Icon=system-help
URL=https://fujinet-vm.readthedocs.io
EOF

chmod +x "$VM_HELP_ICON_PATH"
gio set -t string "$VM_HELP_ICON_PATH" metadata::xfce-exe-checksum "$(sha256sum "$VM_HELP_ICON_PATH" | awk '{print $1}')"

cat <<EOF | tee "$APPLEWIN_HELP_ICON_PATH"
[Desktop Entry]
Version=1.0
Type=Link
Name=AppleWin Help
Comment=Help for AppleWin
Icon=system-help
URL=file:///home/$P_USERNAME/FujiNet/AppleWin/help/toc.html
EOF

chmod +x "$APPLEWIN_HELP_ICON_PATH"
gio set -t string "$APPLEWIN_HELP_ICON_PATH" metadata::xfce-exe-checksum "$(sha256sum "$APPLEWIN_HELP_ICON_PATH" | awk '{print $1}')"

cat <<EOF | tee "$FN_WIKI_ICON_PATH"
[Desktop Entry]
Version=1.0
Type=Link
Name=FujiNet Wiki
Comment=Main FujiNet documentation wiki
Icon=system-help
URL=https://github.com/FujiNetWIFI/fujinet-firmware/wiki
EOF

chmod +x "$FN_WIKI_ICON_PATH"
gio set -t string "$FN_WIKI_ICON_PATH" metadata::xfce-exe-checksum "$(sha256sum "$FN_WIKI_ICON_PATH" | awk '{print $1}')"

cp /home/"$P_USERNAME"/Desktop/*.desktop "$APPS_ROOT_PATH/"
