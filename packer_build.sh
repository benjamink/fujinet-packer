#!/usr/bin/env bash

VERSION="${1:-test}"

echo PACKER_DEBUG=1 packer build -var="vm_version=$VERSION" -force -color=false -machine-readable -on-error=abort . | tee packer.out

echo mega-put output-qemu/fujinet-debian12.ova "FujiNet/VirtualMachine/fujinet-debian12-vbox-$VERSION.ova"

