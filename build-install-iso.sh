#!/usr/bin/env bash

pushd $(dirname $0)
. demo.conf

##
## Clean up the old artifacts
##
podman rmi -f $CONTAINER_REPO:v1
sudo rm -fr bootiso

##
## Build the container
##
podman build -f Containerfile -t $CONTAINER_REPO:v1 \
    --build-arg BOOT_KARGS=$BOOT_KARGS .

##
## Push the built container
##
podman push $CONTAINER_REPO:v1

##
## Generate the config file
##
envsubst '$BOOT_ARGS $EDGE_USER $EDGE_HASH $SSH_PUB_KEY' \
    < config.json.orig > config.json

##
## Generate the ISO
##
sudo podman run --rm -it --privileged -v .:/output \
    -v ./config.json:/config.json \
    --pull newer quay.io/centos-bootc/bootc-image-builder \
    --type iso --tls-verify=false --config /config.json \
    $CONTAINER_REPO:v1

popd
