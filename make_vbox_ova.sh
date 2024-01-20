#!/usr/bin/env bash
set -x

VM_NAME="FujiNet"
VDI_IMAGE="fujinet-debian12.vdi"
CPUS=2
MEMORY=4096
VRAM=16
VBOX_GUEST_ISO="/usr/share/virtualbox/VBoxGuestAdditions.iso"

VBoxManage createvm --name "$VM_NAME" --register
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VDI_IMAGE"
VBoxManage modifyvm "$VM_NAME" --memory $MEMORY --vram $VRAM

VBoxManage guestcontrol "$VM_NAME" updatega --source "$VBOX_GUEST_ISO"

VBoxManage export "$VM_NAME" -o "${VM_NAME}.ova"
