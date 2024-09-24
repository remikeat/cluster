## Instalation

### Talos installation

- Download talos image from https://factory.talos.dev/ by setting values according to talos/boot_assets/assets.yaml
- Extract the image

```
xz -d metal-arm64.raw.xz
```

Prepare the cluster

```
talosctl apply-config --insecure -n 192.168.0.122 --file controlplane.yaml
talosctl bootstrap -n 192.168.0.122
talosctl kubeconfig -n 192.168.0.122
talosctl config endpoint 192.168.0.122
talosctl config nodes 192.168.0.122
```

### Terraform installation

```
terraform init
source .env
terraform apply
```

## Initial configuration (after terraform)

### Fix ingress

```
kubectl edit -n rancher ingress/rancher
```

And remove conflicting cert-manager.io annotations:

```
cert-manager.io/issuer: rancher
cert-manager.io/issuer-kind: Issuer
```

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

### Create applications

```
kubectl apply -f applicationset.yaml
kubectl apply -f applications.yaml
```

## Initial configuration (after argocd)

### Get initial password for elasticsearch

```
kubectl get secrets elasticsearch-es-elastic-user -o json | jq -r .data.elastic | base64 -d
```

Update password in bitwarden secret manager : fluent.env
And update password in bitwarden password manager for kibana/elasticsearch

### Portainer

Create admin account for portainer by accessing portainer.tail4d334.ts.net IMMEDIATELY

### Redmine

- Setup authentication needed
- Disable user self registration
