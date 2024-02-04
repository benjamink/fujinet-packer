#!/usr/bin/env bash
set -x

cat <<EOF | sudo tee /etc/sudoers.d/fujinet 
#Cmnd_Alias FN_RESTART = /usr/bin/systemctl restart fn-emulator-bridge, /usr/bin/systemctl restart fn-pc-apple, /usr/bin/systemctl restart fn-pc-atari 
#Cmnd_Alias FN_START = /usr/bin/systemctl start fn-emulator-bridge, /usr/bin/systemctl start fn-pc-apple, /usr/bin/systemctl start fn-pc-atari 
#Cmnd_Alias FN_STOP = /usr/bin/systemctl stop fn-emulator-bridge, /usr/bin/systemctl stop fn-pc-apple, /usr/bin/systemctl stop fn-pc-atari 
#Cmnd_Alias FN_STATUS = /usr/bin/systemctl status fn-emulator-bridge, /usr/bin/systemctl status fn-pc-apple, /usr/bin/systemctl status fn-pc-atari 
#Cmnd_Alias FN_JOURNALCTL = /usr/bin/journalctl -fu fn-emulator-bridge, /usr/bin/journalctl -fu fn-pc-apple, /usr/bin/journalctl -fu fn-pc-atari 
#
#$P_USERNAME ALL=(ALL) NOPASSWD: FN_RESTART, RN_START, FN_STOP, FN_STATUS, FN_JOURNALCTL
$P_USERNAME ALL=(ALL) NOPASSWD: ALL
EOF 

sudo chmod 440 /etc/sudoers.d/fujinet
