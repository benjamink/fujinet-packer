#!/usr/bin/env bash

VERSION="test" 
COPY_ONLY="false"
LOCAL_ONLY="false"

function usage() {
  echo "$0 [-v version] [-l] [-c] [-h]"
  echo
  echo "  -v <version>      Provide a version for the VM build (default: 'test')"
  echo "  -l                If set build WILL NOT be uploaded to MEGA (local only)" 
  echo "  -c                Just copy the OVA to MEGA"
  echo "  -h                Display this help"
  echo
  exit 1
}

while getopts "v:lch" opt
do
  case "$opt" in
    v) VERSION="$OPTARG" ;;
    l) LOCAL_ONLY="true" ;;
    c) COPY_ONLY="true" ;;
    h) usage ;;
  esac
done

if [[ "$COPY_ONLY" != "true" ]]
then
  PACKER_DEBUG=1 packer build -var="vm_version=$VERSION" -force -color=false -machine-readable -on-error=clean . | tee packer.out
fi

if [[ "$LOCAL_ONLY" != "true" ]]
then 
  mega-put "output/fujinet-debian12-vbox.ova" "FujiNet/VirtualMachine/fujinet-debian12-vbox.ova"
fi
