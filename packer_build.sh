#!/usr/bin/env bash

VERSION="test" 
COPY_ONLY="false"
LOCAL_ONLY="true"
OUTPUT_FLAG=""

function usage() {
  echo "$0 [-o build_output] [-v version] [-l] [-c] [-n] [-h]"
  echo
  echo "  -o <build_output> Set the type of VM to build (default 'virtualbox-iso', alternative 'qemu', 'vmware-iso')"
  echo "  -v <version>      Provide a version for the VM build (default: 'test')"
  echo "  -u                If set build WILL be uploaded to MEGA (local only)" 
  echo "  -c                Just copy the OVA to MEGA"
  echo "  -n                Disable (no) color"
  echo "  -h                Display this help"
  echo
  exit 1
}

while getopts "v:o:lucnh" opt
do
  case "$opt" in
    o) OUTPUT_TYPE="$OPTARG" ;;
    v) VERSION="$OPTARG" ;;
    u) LOCAL_ONLY="false" ;;
    c) COPY_ONLY="true" ;;
    n) COLOR_FLAG="-color=false" ;;
    *) usage ;;
  esac
done

if [[ -n "$OUTPUT_TYPE" ]]
then
  OUTPUT_FLAG="-only=build.${OUTPUT_TYPE}.fujinet"
fi

if [[ "$VERSION" != "test" ]]
then 
  git tag "$VERSION" 
  git push --tags
fi 

if [[ "$COPY_ONLY" != "true" ]]
then
  PACKER_DEBUG=2 packer build -parallel-builds=1 $OUTPUT_FLAG -var="vm_version=$VERSION" -force $COLOR_FLAG -machine-readable . | tee packer.out
fi

if [[ "$LOCAL_ONLY" != "true" ]]
then 
  if [[ "$VERSION" == "test" ]]
  then
    case "$OUTPUT_TYPE" in 
      virtualbox-iso)
        mega-put "output/fujinet-debian12-vbox.ova" "FujiNet/VM-Testing/test-fujinet-debian12-vbox.ova"
        ;;
      qemu)
        mega-put "output-qemu/fujinet-debian12-qemu.qcow2" "FujiNet/VM-Testing/test-fujinet-debian12-qemu.qcow2"
        ;;
      vmware-iso)
        mega-put "output-vmware/fujinet-debian12-vmware.ova" "FujiNet/VM-Testing/test-fujinet-debian12-vmware.ova"
        ;;
      *)
        mega-put "output/fujinet-debian12-vbox.ova" "FujiNet/VM-Testing/test-fujinet-debian12-vbox.ova"
        mega-put "output-qemu/fujinet-debian12-qemu.qcow2" "FujiNet/VM-Testing/test-fujinet-debian12-qemu.qcow2"
        mega-put "output-vmware/fujinet-debian12-vmware.ova" "FujiNet/VM-Testing/test-fujinet-debian12-vmware.ova"
        ;;
    esac  
  else
    case "$OUTPUT_TYPE" in 
      virtualbox-iso)
        mega-put "output/fujinet-debian12-vbox.ova" "FujiNet/VirtualMachine/fujinet-debian12-vbox-${VERSION}.ova"
        ;;
      qemu)
        mega-put "output-qemu/fujinet-debian12-qemu.qcow2" "FujiNet/VirtualMachine/fujinet-debian12-qemu-${VERSION}.qcow2"
        ;;
      vmware-iso)
        mega-put "output-vmware/fujinet-debian12-vmware.ova" "FujiNet/VirtualMachine/fujinet-debian12-vmware-${VERSION}.ova"
        ;;
      *)
        mega-put "output/fujinet-debian12-vbox.ova" "FujiNet/VirtualMachine/fujinet-debian12-vbox-${VERSION}.ova"
        mega-put "output-qemu/fujinet-debian12-qemu.qcow2" "FujiNet/VirtualMachine/fujinet-debian12-qemu-${VERSION}.qcow2"
        mega-put "output-vmware/fujinet-debian12-vmware.ova" "FujiNet/VirtualMachine/fujinet-debian12-vmware-${VERSION}.ova"
        ;;
    esac
  fi
fi
