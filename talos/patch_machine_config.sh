#!/bin/bash
talosctl machineconfig patch worker.yaml \
    --patch @patches/disable-cni.yaml \
    --patch @patches/data-path-mount.yaml \
    --patch @patches/install.yaml \
    --patch @patches/metrics-server.yaml \
    --patch @patches/scheduling-control-plane.yaml \
    --patch @patches/pods-per-node.yaml \
    --patch @patches/device-ownership.yaml \
    --patch @patches/tailscale.yaml \
    --patch @patches/udev-rules.yaml \
    --patch @patches/node-labels.yaml \
    -o worker.yaml

talosctl machineconfig patch controlplane.yaml \
    --patch @patches/disable-cni.yaml \
    --patch @patches/data-path-mount.yaml \
    --patch @patches/install.yaml \
    --patch @patches/metrics-server.yaml \
    --patch @patches/scheduling-control-plane.yaml \
    --patch @patches/pods-per-node.yaml \
    --patch @patches/device-ownership.yaml \
    --patch @patches/tailscale.yaml \
    --patch @patches/udev-rules.yaml \
    --patch @patches/node-labels.yaml \
    -o controlplane.yaml
