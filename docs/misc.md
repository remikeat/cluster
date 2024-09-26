# Misc

### Setup number of replicas for elasticsearch

```
curl -X PUT -L 'https://elasticsearch.tail4d334.ts.net/*/_settings' \
-u "elastic:$PASSWORD" \
-H 'Content-Type: application/json' \
-d '{"index": {"number_of_replicas": 0}}'
```

### Cluster shutdown

```
talosctl shutdown
```

### Retrieve kubeconfig

```
talosctl kubeconfig
tailscale configure kubeconfig tailscale-operator
```

### Reset machine

```
talosctl reset --graceful=false --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --reboot
```

### Debugging

```
kubectl apply -f debug-pod.yaml
kubectl -n debug exec -it pods/debug -- /bin/sh
kubectl delete -f debug-pod.yaml
```

### Validate cloudinit

```
cloud-init schema -c user-data --annotate
```
