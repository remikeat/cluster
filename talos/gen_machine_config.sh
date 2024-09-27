talosctl gen config --with-secrets secrets.yaml \
    --config-patch @patches/disable-cni.yaml \
    --config-patch @patches/data-path-mount.yaml \
    --config-patch @patches/install.yaml \
    --config-patch @patches/metrics-server.yaml \
    --config-patch @patches/scheduling-control-plane.yaml \
    --config-patch @patches/pods-per-node.yaml \
    --config-patch @patches/device-ownership.yaml \
    --config-patch @patches/tailscale.yaml \
    --with-docs=false \
    --with-examples=false \
    cluster https://192.168.0.122:6443
