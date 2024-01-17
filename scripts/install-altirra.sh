#!/usr/bin/env bash
set -x

INSTALL_PATH="/home/$P_USERNAME/FujiNet/Altirra"

# Download 
curl -sLo /tmp/altirra.zip "$P_ALTIRRA_ZIP_URL"

# Install
mkdir -p "$INSTALL_PATH"
cd "$INSTALL_PATH"
unzip /tmp/altirra.zip
rm -f /tmp/altirra.zip 

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
"Devices" = "[{\"tag\":\"custom\",\"params\":{\"hotreload\":false,\"path\":\"Z:\\\\home\\\\$P_USERNAME\\\\FujiNet\\\\emulator\\\\Altirra\\\\netsio.atdevice\"}}]"

[User\Software\virtualdub.org\Altirra\Device config history]
"custom" = "{\"hotreload\":false,\"path\":\"Z:\\\\home\\\\$P_USERNAME\\\\FujiNet\\\\emulator\\\\Altirra\\\\netsio.atdevice\"}"

[User\Software\virtualdub.org\Altirra\Saved filespecs]
"63756476" = "Z:\\home\\$P_USERNAME\\FujiNet\\emulator\\Altirra\\"
EOF