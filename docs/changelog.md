# Changelog

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