#!/usr/bin/env bash

pushd $(dirname $0)

#
# Clean up existing VM
#
virsh destroy cs9-edge-device
virsh undefine cs9-edge-device
rm -f output.txt osbuild.ks osbuild-base.ks

#
# Extract kickstart files
#
osirrox -indev install.iso -extract osbuild.ks osbuild.ks
osirrox -indev install.iso -extract osbuild-base.ks osbuild-base.ks

#
# Launch virtual edge device but use bridged networking
#
virt-install \
    --name cs9-edge-device \
    --memory 4096 \
    --vcpus 4 \
    --network bridge=virbr0 \
    --location install.iso,kernel=images/pxeboot/vmlinuz,initrd=images/pxeboot/initrd.img \
    --initrd-inject $(pwd)/osbuild.ks \
    --extra-args "fips=1 console=ttyS0,115200n8 inst.ks=file:/osbuild.ks" \
    --os-variant=centos-stream9 \
    --disk size=64 \
    --graphics none \
    --noreboot 2>&1 | \
tee output.txt

popd
