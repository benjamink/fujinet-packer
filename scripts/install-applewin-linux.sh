#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq git build-essential cmake libghc-zlib-dev libslirp-dev libminizip-dev libpcap-dev libyaml-dev libboost-all-dev libsdl2-image-dev libglib2.0-bin

LAUNCHER_PATH="/home/$P_USERNAME/Desktop/AppleWin.desktop"
WEB_URL_PATH="/home/$P_USERNAME/Desktop/FujiNet-Apple-WebUI.desktop"
FN_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
INSTALL_PATH="$FN_PATH/AppleWin"
mkdir -p "$FN_PATH"
cd "$FN_PATH" || exit

git clone https://github.com/FujiNetWIFI/AppleWin.git
cd AppleWin || exit
git fetch --all
git checkout linux
git submodule update --init --recursive
./build.sh -cbg
cd build || exit
sudo make install 

mkdir -p "/home/$P_USERNAME/.applewin"
cat <<EOF > "/home/$P_USERNAME/.applewin/applewin.conf"
[Configuration\Slot 0]
Card type=17

# FujiNet-PC
[Configuration\Slot 7]
Card type=25

[Configuration\Slot Auxiliary]
Card type=13

[sa2\geometry]
width=800
height=600
x=324
y=88

[Configuration]
Video Emulation=1
Video Style=0
Monochrome Color=12632256
Video Refresh Rate=2
EOF

cat <<EOF > "$INSTALL_PATH/start-applewin.sh"
#!/usr/bin/env bash 

LOAD_DISK=""
if [[ -n "\$1" ]]
then
  LOAD_DISK="-1 \$1"
fi 

/usr/local/bin/sa2 --log \$LOAD_DISK

EOF

chmod +x "$INSTALL_PATH/start-applewin.sh"

cat <<EOF > "$LAUNCHER_PATH"
[Desktop Entry]
Encoding=UTF-8
Name=FujiNet AppleWin
Comment=FujiNet connected to AppleWin for Linux
Type=Application
Exec=$INSTALL_PATH/start-applewin.sh
Icon=/usr/local/share/applewin/resource/APPLEWIN.ICO
EOF

chmod +x "$LAUNCHER_PATH"
gio set -t string "$LAUNCHER_PATH" metadata::xfce-exe-checksum "$(sha256sum "$LAUNCHER_PATH" | awk '{print $1}')"

cat <<EOF > "$WEB_URL_PATH"
[Desktop Entry]
Version=1.0
Name=FujiNet Apple Web UI
Comment=Web UI admin console for FujiNet Apple
Type=Link
Icon=/home/$P_USERNAME/Pictures/fn-logo-black.png
URL=http://localhost:8001
EOF

chmod +x "$WEB_URL_PATH"
gio set -t string "$WEB_URL_PATH" metadata::xfce-exe-checksum "$(sha256sum "$WEB_URL_PATH" | awk '{print $1}')"