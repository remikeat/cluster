# Password

## Initial passwords

### Get bootstrap password for Rancher

```
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
```

### Get password for ceph dashboard

```
kubectl get -n rook-ceph secrets/rook-ceph-dashboard-password -o jsonpath={.data.password} | base64 -d
```

### Get initial password for argocd and change password

```
argocd admin initial-password -n argocd
argocd login argocd.tail4d334.ts.net
argocd account update-password
kubectl delete -n argocd secrets/argocd-initial-admin-secret
```

### Get initial password for elasticsearch

```
kubectl -n elastic-system get secrets elasticsearch-es-elastic-user -o json | jq -r .data.elastic | base64 -d
```

Update password in vault : kv/data/infra/elastic#password
And update password in password manager for kibana/elasticsearch

## Password creation

### How to encode in base64

```
echo -n "username:password" | base64
```

### How to create htpasswd data

```
htpasswd -n username
```

### How to create password hash

```
openssl passwd -6 password
```

### Generate TLS certificates

```
openssl req -new -x509 -nodes -newkey ec:<(openssl ecparam -name secp384r1) -keyout ./tls.key -out ./tls.crt -days 1095 -subj "/CN=kong_clustering"
vault kv put -mount=kv kong certificate=@tls.crt private_key=@tls.key
rm tls.key tls.crt
```

## RabbitMQ

### User

```
kubectl -n rabbitmq get secret rabbitmq-default-user -o jsonpath="{.data.username}" | base64 -d
kubectl -n rabbitmq get secret rabbitmq-default-user -o jsonpath="{.data.password}" | base64 -d
```
