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

### Get public key from github

```
curl -s https://api.github.com/users/remikeat/keys | jq -r .[].key
```

### Merge talosconfig

```
talosctl config merge ./talosconfig
```

### Debug pod

```
kubectl run -it --rm -n rook-ceph --image ubuntu:latest --privileged debug
```

### Wipe disk for ceph to use

Carefully check which disk to wipe with

```
lsblk
```

```
apt update && apt install gdisk -y
sgdisk --zap-all /dev/sda
```

### Get kong ip

```
kubectl get service -n kong kong-open-appsec-kong-proxy -o jsonpath='{range .status.loadBalancer.ingress[0]}{@.ip}{@.hostname}{end}'
```

### Kafka

```
kubectl -n kafka run kafka-producer -it --image=quay.io/strimzi/kafka:0.43.0-kafka-3.8.0 --rm --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server kafka-kafka-bootstrap:9092 --topic my-topic
```

```
kubectl -n kafka run kafka-consumer -it --image=quay.io/strimzi/kafka:0.43.0-kafka-3.8.0 --rm --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server kafka-kafka-bootstrap:9092 --topic my-topic --from-beginning
```
