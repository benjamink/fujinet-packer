#!/usr/bin/env bash
set -x

sudo mkdir -p /tmp/vbox
sudo mount -o loop "/home/$P_USERNAME/VBoxGuestAdditions.iso" /tmp/vbox 

sudo mount
sudo ls -la /tmp/vbox

sudo apt-get install -qq -y build-essential dkms bzip2 tar "linux-headers-$(uname -r)"

sudo sh /tmp/vbox/VBoxLinuxAdditions.run --nox11 || true 

if ! sudo modinfo vboxsf >/dev/null 2>&1
then
  echo "Cannot find vbox kernel module. Installation of guest additions unsuccessful!"
  exit 1
fi

echo "unmounting and removing the vbox ISO"
sudo umount /tmp/vbox
sudo rm -rf /tmp/vbox
rm -f "/home/$P_USERNAME/VBoxGuestAdditions.iso"
