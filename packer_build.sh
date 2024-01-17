#!/usr/bin/env bash

PACKER_DEBUG=1 packer build -force -color=false -machine-readable -on-error=abort . | tee packer.out
