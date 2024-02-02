#!/usr/bin/env bash

VERSION="test" 
LOCAL_ONLY="False"

function usage() {
  echo "$0 [-v version] [-l] [-h]"
  echo
  echo "  -v <version>      Provide a version for the VM build (default: 'test')"
  echo "  -l                If set build WILL NOT be uploaded to MEGA (local only)" 
  echo "  -h                Display this help"
  echo
  exit 1
}

while getopts "v:lh" opt
do
  case "$opt" in
    v) VERSION="$OPTARG" ;;
    l) LOCAL_ONLY="true" ;;
    h) usage ;;
  esac
done

PACKER_DEBUG=1 packer build -var="vm_version=$VERSION" -force -color=false -machine-readable -on-error=abort . | tee packer.out

if [[ $LOCAL_ONLY != "true" ]]
then 
  mega-put output-qemu/fujinet-debian12.ova "FujiNet/VirtualMachine/fujinet-debian12-vbox-$VERSION.ova"
fi
