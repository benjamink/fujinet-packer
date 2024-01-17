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

# Build fujinet-pc for AppleWin w/ SP+SLIP for Linux 

```shell
git clone https://github.com/FujiNetWIFI/fujinet-platformio.git
cd fujinet-platformio
./build.sh -p APPLE
```

Run: 

```shell
cd fujinet-platformio/build/dist
./run-fujinet
```

## fujinet-pc SystemD init

```
[Unit]
Description=FujiNet PC for Apple
After=remote-fs.target
After=syslog.target

[Service]
WorkingDirectory=/home/vcf/FujiNet/fn-pc-apple
User=vcf
Group=vcf
ExecStart=/home/vcf/FujiNet/fn-pc-apple/run-fujinet

[Install]
WantedBy=multi-user.target
```

```
sudo cp /path/to/fn-pc.apple.service /etc/systemd/system/fn-pc-apple.service
sudo systemctl daemon-reload
sudo systemctl start fn-pc-apple
```

>**_NOTE:_** The following is DEPRECATED!  Build from `fujinet-platformio` instead!
>
>```shell
>apt install python-mbed-ls python3-pip python3-jinja2 python3-yaml libexpat-dev libmbedtls-dev
>```
>
>```shell
>git clone https://github.com/FujiNetWIFI/fujinet-pc.git
>git fetch --all
>git checkout sp-slip
>cd fujinet-pc/build
>cmake .. -DCMAKE_BUILD_TYPE:STRING=Debug -G "Unix Makefiles"
>cmake --build .
>cmake --build . --target dist
>```

# Build fujinet-pc for Atari w/ SP+SLIP for Linux

## fujinet-pc

```shell
git clone https://github.com/FujiNetWIFI/fujinet-platformio.git
cd fujinet-platformio
./build.sh -p ATARI
```

Run: 

```shell
cd fujinet-platformio/build/dist
./run-fujinet
```

## fujinet-pc SystemD init

```
[Unit]
Description=FujiNet PC for Atari
After=remote-fs.target
After=syslog.target
Requires = fn-pc-atari-bridge.service

[Service]
WorkingDirectory=/home/vcf/FujiNet/fn-pc-atari
User=vcf
Group=vcf
ExecStart=/home/vcf/FujiNet/fn-pc-atari/run-fujinet

[Install]
WantedBy=multi-user.target
```

>**_NOTE:_** This will auto-start the `fn-pc-atari-bridge` service as a dependency.

```
sudo cp /path/to/fn-pc-atari.service /etc/systemd/system/fn-pc-atari.service
sudo systemctl daemon-reload
sudo systemctl start fn-pc-atari
```

## fujinet-emulator-bridge

Run: 

```shell
git clone https://github.com/FujiNetWIFI/fujinet-emulator-bridge.git
cd fujinet-emulator-bridge
python -m netsiohub
```

## fujinet-emulator-bridge SystemD init

```
[Unit]
Description=FujiNet PC for Atari Bridge
After=remote-fs.target
After=syslog.target

[Service]
WorkingDirectory=/home/vcf/FujiNet/fn-pc-atari/fujinet-emulator-bridge/fujinet-bridge
User=vcf
Group=vcf
ExecStart=/usr/bin/python -m netsiohub

[Install]
WantedBy=multi-user.target
```

```
sudo cp /path/to/fn-pc-atari-bridge.service /etc/systemd/system/fn-pc-atari-bridge.service
sudo systemctl daemon-reload
sudo systemctl start fn-pc-atari-bridge
```

## Setup Altirra to use FujiNet-PC

Set Altirra config:

1. Open `System -> Configure System` menu
2. Select `Peripherals -> Devices` tab
3. Select `Other Devices -> Custom Device` item
4. Click `Add...`
5. Navigate to `path/to/fujinet-emulator-bridge/altirra-custom-device/netsio.atdevice`
6. Select `Computer -> Acceleration` tab
7. Uncheck `Fast boot`

>**_NOTE:_** See the [fujinet-pc-launcher docs](https://github.com/a8jan/fujinet-pc-launcher/blob/master/Install.md#4-connect-altirra-with-fujinet) for illustrated instructions.

Alternatively configure `Altirra.ini` & start Altirra with `wine altirra.exe /portable` to use the INI configuration:

```ini
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
"Devices" = "[{\"tag\":\"custom\",\"params\":{\"hotreload\":false,\"path\":\"Z:\\\\path\\\\to\\\\fujinet-emulator-bridge\\\\altirra-custom-device\\\\netsio.atdevice\"}}]"

[User\Software\virtualdub.org\Altirra\Device config history]
"custom" = "{\"hotreload\":false,\"path\":\"Z:\\\\path\\\\to\\\\fujinet-emulator-bridge\\\\altirra-custom-device\\\\netsio.atdevice\"}"

[User\Software\virtualdub.org\Altirra\Saved filespecs]
"63756476" = "Z:\\home\\path\\\\to\\\\fujinet-emulator-bridge\\\\altirra-custom-device\\"
```

>**_NOTE:_** Update the `"Devices"`, `"custom"`, & `"63756476"` lines with the path to the `netsio.atdevice`.  
>
>Not sure if the `[User\Software\veritualdub.org\Altirra\Saved filespecs]` section needs to be configured or if it will auto-configure on first run from the other settings.

# Build fujinet-pc-launcher GUI for Linux

_TBD_

# Running FujiNet App via AppleWin

```shell
cd path/to/applewin
./sa2 --log -1 path/to/fujinet-apps/testsp2/dist/testsp2.po
```