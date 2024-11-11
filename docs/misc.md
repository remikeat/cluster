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

### Deploy advanced model

```
kubectl create configmap -n kong advanced-model-config --from-file open-appsec-advanced-model.tgz
kubectl rollout restart deployment -n kong kong-open-appsec-kong
```

### Vault

```
vault kv get --mount=kv app
vault kv put --mount=kv app password=
```

### List cpu/memory requests

```
kubectl get pods -A -o custom-columns="NAMESPACE:.metadata.namespace,NAME:.metadata.name,REQUEST_CPU:.spec.containers[*].resources.requests.cpu,REQUEST_MEM:.spec.containers[*].resources.requests.memory" --sort-by="{.spec.containers[*].resources.requests.cpu}"
```

### List all IPs

```
kubectl get svc -A -o custom-columns="NAME:.metadata.name,IP:.status.loadBalancer.ingress[*].ip" --sort-by="{.status.loadBalancer.ingress[*].ip}" | grep -v "<none>"
```

### Get token to log in argo workflows

```
kubectl -n argo-workflows exec -it $(kubectl -n argo-workflows get pods -l app=server -o json | jq -r .items[].metadata.name) -- argo auth token
```

### Run cronjob manually

```
kubectl create job -n observability --from=cronjob/jaeger-spark-dependencies-cron jaeger-spark-dependencies-manual
```
