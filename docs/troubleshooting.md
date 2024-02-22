# Troubleshooting

## Known Issues

### VirtualBox Guest Additions Version Warning

Currently the VM is being built with VirtualBox version 6.x due to technical reasons.  This is an older version of VirtualBox & is likely older than the version of the VirtualBox running on your computer (version 7.x is the current version as of this writing).  Because of this the VM will display a warning about the installed Guest Additions being an older version than the VirtualBox the VM is running in.  Below is an example of this warning message as it appears.  The warning message will disappear on its own after a few seconds & shouldn't be displayed again.  This will be fixed in a future version of the VM.

![Guest Additions Version Mismatch](./media/vbox-guest-additions-notice.png)

## Viewing Logs

### FujiNet Atari SIO Emulator Bridge

The Atari SIO Emulator Bridge provides a virtual SIO connection between the Altirra emulator & the FujiNet PC virtual device.  To tail the logs run the following command:

```shell
sudo journalctl -fu fn-emulator-bridge.service
```

### Virtual FujiNet Device for Atari

To tail the logs for the virtual FujiNet device for Atari run the following command:

```shell
sudo journalctl -fu fn-pc-atari.service
```

### Virtual FujiNet Device for Apple

To tail the logs for the virtual FujiNet device for Apple run the following command:

```shell
sudo journalctl -fu fn-pc-apple.service
```