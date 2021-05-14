#!/bin/bash

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -vmware|--vmware)
      BUILD_VMWARE="vmware-iso"
      shift
      ;;
    -virtualbox|--virtualbox)
      BUILD_VBOX="virtualbox-iso"
      shift
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [[ -n $BUILD_VMWARE && -n $BUILD_VBOX ]]; then
  ONLY="$BUILD_VBOX,$BUILD_VMWARE"
elif [[ -n $BUILD_VMWARE ]]; then
  ONLY="$BUILD_VMWARE"
elif [[ -n $BUILD_VBOX ]]; then
  ONLY="$BUILD_VBOX"
else
  ONLY="$BUILD_VBOX,$BUILD_VMWARE"
fi

PACKER_LOG=1 packer build  \
    -only=$ONLY \
  --var iso_url=iso/windows_10.iso \
  --var iso_checksum=sha256:f1a4f2176259167cd2c8bf83f3f5a4039753b6cc28c35ac624da95a36e9620fc \
  box-config-ami.json

