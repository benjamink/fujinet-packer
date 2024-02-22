# Getting Started

## Importing the VM

The results of building the Packer configuration is a VirtualBox OVA appliance VM that can be imported into VirtualBox under the `File` -> `Import Appliance...` menu.  The defaults should work fine when importing the OVA.

## Running the VM

**_NOTE:_** This VM is configured with 2 CPUs & 4GB RAM by default.  This should be considered a **MINIMUM**!  Increasing the RAM to 8GB or more will make using the VM **MUCH** more enjoyable.

The default authentication for the built VM are as follows: 

- Username: `fujinet`
- Password: `online`

## Pre-configured Items

- Altirra - run via Wine - Starts the FujiNet-PC (`fn-pc-atari.service`) & FujiNet Emulator Bridge (`fn-emulator-bridge.service`) services automatically when started from the desktop launcher icon
- AppleWin for Linux - Starts the FujiNet-PC (`fn-pc-apple.service`) service automatically when started from the desktop launcher icon
- [fujinet-platformio](https://github.com/FujiNetWIFI/fujinet-platformio) - Git repository cloned to `$HOME/FujiNet/fujinet-platformio`
- [fujinet-apps](https://github.com/FujiNetWIFI/fujinet-apps) - Git repository cloned to `$HOME/FujiNet/fujinet-apps`

See the [FujiNet Wiki](https://github.com/FujiNetWIFI/fujinet-platformio/wiki) for more details on using FujiNet.
