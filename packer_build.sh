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
    *) usage ;;
  esac
done

if [[ "$VERSION" != "test" ]]
then 
  git tag "$VERSION" 
  git push --tags
fi 

if [[ "$COPY_ONLY" != "true" ]]
then
  PACKER_LOG=1 PACKER_DEBUG=2 packer build -var="vm_version=$VERSION" -force -color=false -machine-readable . | tee packer.out
fi

if [[ "$LOCAL_ONLY" != "true" ]]
then 
  if [[ "$VERSION" == "test" ]]
  then
    mega-put "output/fujinet-debian12-vbox.ova" "FujiNet/VM-Testing/test-fujinet-debian12-vbox.ova"
  else
    mega-put "output/fujinet-debian12-vbox.ova" "FujiNet/VirtualMachine/fujinet-debian12-vbox-${VERSION}.ova"
  fi
fi
