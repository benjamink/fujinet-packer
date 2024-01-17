# AppleWin for Linux 

```shell
apt install build-essential cmake libghc-zlib-dev libslirp-dev libminizip-dev libpcap-dev libyaml-dev libboost-all-dev libsdl2-image-dev 
```

```shell
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
```

## Configuration

`~/.applewin/applewin.conf`:

```ini
[Configuration\Slot 0]
Card type=17

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
```

# Install cc65 & FujiNet Apps

```shell
apt install default-jre cc65
```

```shell
git clone https://github.com/FujiNetWIFI/fujinet-apps.git 
```

# Set Python3 as Default Python

```shell
apt install python-is-python3
```

or 

```shell
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
```

# Build fujinet-pc-launcher w/ SP+SLIP for Linux

READ THIS: https://github.com/a8jan/fujinet-pc-launcher/blob/master/Build.md

or

READ THIS: https://github.com/a8jan/fujinet-pc-launcher/blob/master/ScriptsUsage.md

# Build fujinet-pc w/ SP+SLIP for Linux 

```shell
apt install python-mbed-ls python3-pip python3-jinja2 python3-yaml libexpat-dev libmbedtls-dev
```

```shell
git clone https://github.com/FujiNetWIFI/fujinet-pc.git
git fetch --all
git checkout sp-slip
cd fujinet-pc/build
cmake .. -DCMAKE_BUILD_TYPE:STRING=Debug -G "Unix Makefiles"
cmake --build .
cmake --build . --target dist
```

# Running FujiNet App via AppleWin

```shell
cd path/to/applewin
./sa2 --log -1 path/to/fujinet-apps/testsp2/dist/testsp2.po
```