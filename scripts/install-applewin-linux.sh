#!/usr/bin/env bash
set -x

sudo apt-get install -y -qq git build-essential cmake libghc-zlib-dev libslirp-dev libminizip-dev libpcap-dev libyaml-dev libboost-all-dev libsdl2-image-dev

FN_PATH="${P_FN_PATH:-/home/$P_USERNAME/FujiNet}"
INSTALL_PATH="$FN_PATH/AppleWin"
mkdir -p "$FN_PATH"
cd "$FN_PATH"

git clone https://github.com/FujiNetWIFI/AppleWin.git
cd AppleWin
git fetch --all
git checkout linux
git submodule update --init --recursive
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_SA2=on .. 
make
sudo make install 

mkdir -p "/home/$P_USERNAME/.applewin"
cat <<EOF > "/home/$P_USERNAME/.applewin/applewin.conf"
[Configuration\Slot 0]
Card type=17

# FujiNet-PC
[Configuration\Slow 5]
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

echo <<EOF > "$INSTALL_PATH/start-applewin.sh"
#!/usr/bin/env bash 

sudo systemctl start fn-pc-apple
sleep 10
/usr/local/bin/sa2 --log
EOF

chmod +x "$INSTALL_PATH/start-altirra.sh"

echo <<EOF > "/home/$P_USERNAME/Desktop/AppleWin.desktop"
[Desktop Entry]
Encoding=UTF-8
Name=AppleWin
Comment=AppleWin for Linux
Type=Application
Exec=$INSTALL_PATH/start-applewin.sh
Icon=
EOF
