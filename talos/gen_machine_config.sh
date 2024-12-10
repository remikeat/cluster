#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

IP_ADDRESS=$1

talosctl gen config --with-secrets secrets.yaml \
    --config-patch @patches/disable-cni.yaml \
    --config-patch @patches/data-path-mount.yaml \
    --config-patch @patches/install.yaml \
    --config-patch @patches/metrics-server.yaml \
    --config-patch @patches/scheduling-control-plane.yaml \
    --config-patch @patches/pods-per-node.yaml \
    --config-patch @patches/device-ownership.yaml \
    --config-patch @patches/tailscale.yaml \
    --config-patch @patches/udev-rules.yaml \
    --config-patch @patches/node-labels.yaml \
    --config-patch @patches/registries.yaml \
    --with-docs=false \
    --with-examples=false \
    cluster https://$IP_ADDRESS:6443
