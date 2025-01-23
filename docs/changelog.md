# Changelog

Visit the [Getting Started](gettingstarted.md) page for details on downloading & installing the latest version of the VM.

## 0.6.0 

- 2025-01-25
  - Features 
    - General `fujinet-firmware` updates
    - Add CoCo emulation via MAME 
    - Add desktop shortcut to `upgrade_vm` 

## 0.5.3

- 2024-08-05
  - Features
    - General `fujinet-firmware` updates
    - Add VMWare OVA build
    - `upgrade_vm` script to do in-place upgrade of components in the VM

## 0.5.2

- 2024-05-08
  - Features
    - General `fujinet-firmware` updates
    - `dir2atr`, `adir` & `ataricom` utilities are now installed from source (see [HiassofT's Atari 8bit World](https://www.horus.com/~hias/atari/) for details)

## 0.5.1

- 2024-04-11
  - Features
    - Updates to `fujinet-firmware` (FujiNet PC for Atari & Apple) [Commits since 2024-03-29](https://github.com/FujiNetWIFI/fujinet-firmware/commits/master/?since=2024-03-29&until=2024-04-11)
      - Updates to SSL certificates
      - Support for TCP in TNFS client

## 0.5.0

- 2024-03-29
  - Features:
    - Using a new build of AppleWin that includes a merge of the latest upstream changes
      - Notable is that the Linux version has updated the hotkeys a little to be more "standard", so `F8` is settings, and `Alt-F4` is exit (as opposed to `F2`/`F3` as they used to be)
    - Latest updates to `fujinet-firmware` & `fujinet-apps` repositories
    - QEMU/Libvirt `qcow2` image format is now built as well (beta)


## 0.4.3

- 2024-03-25
  - Features:
    - Updates to `fujinet-lib` merged into main branch
    - `run-nc` script added to make demo'ing `netcat` to the VM guest `localhost` easier

## 0.4.2

- 2024-03-20
  - Features:
    - Fresh build with `fujinet-lib` merged into main branch

## 0.4.1

- 2024-03-12
  - Features:
    - Fresh build with SMB/FTP support built into CONFIG

## 0.4.0

- 2024-03-10
  - Features:
    - Fresh build with latest SP-to-SLIP interface changes in the [fujinet-firmware](https://github.com/FujiNetWIFI/fujinet-firmware) project
  - Maintenance:
    - Rename `fujinet-platformio` GitHub repositories to `fujinet-firmware` to follow upstream project changes

## 0.3.0

- 2024-02-12
  - Features: 
    - Enable auto-login for `fujinet` user
    - Create `FujiNet` menu item with launchers for emulators & links to documentation
    - Enabled audio output
    - Enabled copy/paste bi-directionally to/from the VM to the host
    - Add shortcut link launchers to the desktop for quick access to the virtual FujiNet Web UIs
    - Improved help & usage documentation for the FujiNet VM
      - Using [ReadTheDocs.io](https://readthedocs.io) for documentation hosting
  - Bug Fixes:
    - Fixed issue with building virtual FujiNet services from recent upstream FujiNet
      - Apple `fn-pc-apple` was being built instead of Atari `fn-pc-atari` causing conflicts
    - Disable screen locking which gets stuck in a loop that can't be exited
    - Fix Altirra help documentation not displaying due to missing Gecko in Wine

## 0.2.0

- Previous stable build
