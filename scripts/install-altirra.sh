#!/usr/bin/env bash
set -x

INSTALL_PATH="$P_FN_PATH/Altirra"
NETSIO_DEV_PATH="Z:$(echo "$INSTALL_PATH/netsio.atdevice" | sed 's#/#\\\\\\\\#g')"

sudo apt-get install -y -qq git

# Clone fujinet-emulator-bridge
mkdir -p "$INSTALL_PATH"
cd "$INSTALL_PATH"
git clone https://github.com/FujiNetWIFI/fujinet-emulator-bridge emulator

cat <<EOF | sudo tee /etc/system/systemd/fn-emulator-bridge.service
[Unit]
Description=FujiNet PC for Atari Bridge
After=remote-fs.target
After=syslog.target

[Service]
WorkingDirectory=$INSTALL_PATH/fujinet-emulator-bridge/fujinet-bridge
User=$P_USERNAME
Group=$P_USERNAME
ExecStart=/usr/bin/python -m netsiohub

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

# Install Altirra
curl -sLo altirra.zip "$P_ALTIRRA_ZIP_URL"
unzip altirra.zip
rm -f altirra.zip 

# Configure
cat <<EOF > "$INSTALL_PATH/Altirra.ini"
; Altirra settings file. EDIT AT YOUR OWN RISK.

[User\Software\virtualdub.org\Altirra]
"ShownSetupWizard" = 1

[User\Software\virtualdub.org\Altirra\Settings]
"Display: Direct3D9" = 0
"Display: 3D" = 0
"Display: Use 16-bit surfaces" = 0
"Display: Accelerate screen FX" = 1

[User\Software\virtualdub.org\Altirra\Profiles\00000000]
"Kernel: Fast boot enabled" = 0
"Devices" = "[{\"tag\":\"custom\",\"params\":{\"hotreload\":false,\"path\":\"$NETSIO_DEV_PATH\"}}]"

[User\Software\virtualdub.org\Altirra\Device config history]
"custom" = "{\"hotreload\":false,\"path\":\"$NETSIO_DEV_PATH\"}"
EOF

# This is probably not needed in the Altirra.ini
#[User\Software\virtualdub.org\Altirra\Saved filespecs]
#"63756476" = "$(echo "${NETSIO_DEV_PATH%\\*}" | sed 's#\\\\#\\#g')"

echo <<EOF > "$INSTALL_PATH/start-altirra.sh"
#!/usr/bin/env bash 

sudo systemctl start fn-pc-atari
sleep 10
wine $INSTALL_PATH/Altirra64.exe /portable
EOF

chmod +x "$INSTALL_PATH/start-altirra.sh"

echo <<EOF > "/home/$P_USERNAME/Desktop/Altirra.desktop"
[Desktop Entry]
Encoding=UTF-8
Name=Altirra
Comment=Altirra in Wine
Type=Application
Exec=$INSTALL_PATH/start-altirra.sh
Icon=
EOF