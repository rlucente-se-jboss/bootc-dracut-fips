#!/usr/bin/env bash

#
# Launch virtual edge device but use bridged networking
#
virsh start cs9-edge-device && virsh console cs9-edge-device \
    2>&1 | tee output.txt
