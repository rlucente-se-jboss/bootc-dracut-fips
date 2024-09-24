#!/usr/bin/env bash

#
# Launch virtual edge device
#
virsh start rhel9-edge-device && virsh console rhel9-edge-device \
    2>&1 | tee output.txt
