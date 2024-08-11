#!/bin/bash
talosctl machineconfig patch worker.yaml \
    --patch @patches/disable-cni.yaml \
    --patch @patches/data-path-mount.yaml \
    -o worker.yaml

talosctl machineconfig patch controlplane.yaml \
    --patch @patches/disable-cni.yaml \
    --patch @patches/data-path-mount.yaml \
    -o controlplane.yaml
