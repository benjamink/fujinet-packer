#!/usr/bin/env bash 
set -x 

sudo apt-get install -qq -y gcc g++ gcc-multilib autoconf automake libtool flex bison gdb libsdl2-dev fontconfig qtbase5-dev qtbase5-dev-tools libfontconfig-dev libsdl2-ttf-dev

LAUNCHER_PATH="/home/$P_USERNAME/Desktop/CoCoMAME.desktop"
CODE_PATH="${P_FN_PATH}/MAME"
git clone https://github.com/mamedev/mame.git "$CODE_PATH"
cd "$CODE_PATH" || exit

make SUBTARGET=cocomame SOURCES=trs/coco12.cpp,trs/coco3.cpp

wget -O roms/coco.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco.zip
wget -O roms/coco2.zip https://colorcomputerarchive.com/repo/ROMS/MAME-MESS/coco2.zip
wget -O roms/coco2b.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco2b.zip
wget -O roms/coco2bh.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco2bh.zip
wget -O roms/coco2h.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco2h.zip
wget -O roms/coco2_hdb1.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco2_hdb1.zip
wget -O roms/coco3.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco3.zip
wget -O roms/coco3h.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco3h.zip
wget -O roms/coco3p.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco3p.zip
wget -O roms/coco3_hdb1.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco3_hdb1.zip
wget -O roms/coco_fdc.zip https://colorcomputerarchive.com/repo/ROMs/MAME-MESS/coco_fdc.zip

#./cocomame coco2b -window -ext fdc,bios=hdbk3
cat <<EOF > "$LAUNCHER_PATH"
[Desktop Entry]
Encoding=UTF-8
Name=FujiNet CoCo MAME
Comment=FujiNet connected to CoCo MAME
Type=Application
Exec=$CODE_PATH/cocomame coco2b -window -ext fdc.bios=hdbk3 fdc,bios=hdbk3 -skip_gameinfo
Path=$CODE_PATH
Icon=org.Xfce.settings.color
EOF

chmod +x "$LAUNCHER_PATH"
gio set -t string "$LAUNCHER_PATH" metadata::xfce-exe-checksum "$(sha256sum "$LAUNCHER_PATH" | awk '{print $1}')"
