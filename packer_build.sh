#!/usr/bin/env bash

VERSION="$1"

PACKER_DEBUG=1 packer build -force -color=false -machine-readable -on-error=abort . | tee packer.out

mega-put output-qemu/fujinet-debian12.ova "FujiNet/VirtualMachine/fujinet-debian12-vbox-$VERSION.ova"

#qemu-img convert -p -O vdi output-qemu/debian-12-qemu.qcow2 ~/fujinet-debian12.vdi
