#!/bin/bash
talosctl machineconfig patch worker.yaml \
    --patch @talos_patches/disable-cni.yaml \
    --patch @talos_patches/data-path-mount.yaml \
    -o worker.yaml

talosctl machineconfig patch controlplane.yaml \
    --patch @talos_patches/disable-cni.yaml \
    --patch @talos_patches/data-path-mount.yaml \
    -o controlplane.yaml
