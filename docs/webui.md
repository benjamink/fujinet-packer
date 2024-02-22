# FujiNet Web Interface Usage

The FujiNet Web UI can be launched for the various virtual FujiNet devices using the FujiNet icons on the desktop.  Double-clicking on these icons will open the web browser to the appropriate URL to display the Web UI.

## FujiNet for Atari

The Atari FujiNet Web UI can be opened at any time regardless of whether the Altirra emulator has been started or not.  Note the host name pre-defined in the UI indicating which virtual FujiNet the UI is related to:

![Atari FujiNet Web UI](./media/fujinet-web-atari.png)

## FujiNet for Apple II

The Apple FujiNet Web UI **_cannot_** be loaded **_without_** running the AppleWin emulator first.  The virtual FujiNet device requires a connection to the emulated Apple computer before it will start the web service.

![Web UI fails without AppleWin Running](./media/fujinet-webui-failed.png)

Once AppleWin has been started the web UI will work properly.  Again, note the highlighted host name indicating the web UI's association to the virtual FujiNet.

![Apple FujiNet Web UI](./media/fujinet-apple-webui-running.png)

## Restarting the Virtual FujiNet Device

Either of the virtual FujiNet devices can be restarted using the Web UI.  This is generally needed if the device needs to be reset for some reason or other.  In order to reset, click on the `Restart` button (highlighted below) which will then turn into a `Confirm` button.  Click the button a 2nd time to confirm the restart.  The web UI will reload when the device has been restarted successfully. 

![Restart FujiNet Device](./media/fujinet-restart-button.png)
