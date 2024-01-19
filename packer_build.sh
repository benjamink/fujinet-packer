#!/usr/bin/env bash

PACKER_DEBUG=1 packer build -force -color=false -machine-readable -on-error=abort . | tee packer.out

qemu-img convert -p -O vdi output-qemu/debian-12-qemu.qcow2 ~/fujinet-debian12.vdi
