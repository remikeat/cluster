#!/bin/bash
talosctl machineconfig patch worker.yaml \
    --patch @patches/disable-cni.yaml \
    --patch @patches/data-path-mount.yaml \
    --patch @patches/install.yaml \
    --patch @patches/metrics-server.yaml \
    --patch @patches/scheduling-control-plane.yaml \
    -o worker.yaml

talosctl machineconfig patch controlplane.yaml \
    --patch @patches/disable-cni.yaml \
    --patch @patches/data-path-mount.yaml \
    --patch @patches/install.yaml \
    --patch @patches/metrics-server.yaml \
    --patch @patches/scheduling-control-plane.yaml \
    -o controlplane.yaml
