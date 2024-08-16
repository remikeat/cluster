### Talos installation

- Download talos image from https://factory.talos.dev/ by setting values according to talos/boot_assets/assets.yaml
- Extract the image

```
xz -d metal-arm64.raw.xz
```

Prepare the cluster

```
talosctl apply-config --insecure -n 192.168.0.138 --file controlplane.yaml
talosctl apply-config --insecure -n 192.168.0.168 --file worker.yaml
talosctl apply-config --insecure -n 192.168.0.226 --file worker.yaml
talosctl bootstrap -n 192.168.0.138
talosctl kubeconfig -n 192.168.0.138
```

### Terraform installation

```
terraform init
source .env
terraform apply
```

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

### Get initial password for argocd

```

argocd admin initial-password -n argo-cd

```

### Login in argocd

```

argocd login argocd.remikeat.com

```

### Change password

```

argocd account update-password

```

### Delete secret

```

kubectl delete -n argo-cd secrets/argocd-initial-admin-secret

```

### ArgoCD configuration

Create a github token and connect the repo in argocd

### Bitwarden configuration

Create a secret in bitwarden secret manager with the following values

- name: grafana
- value:

```
  grafana:
    adminPassword: <GRAFANA_PASSWORD>
```

And update argocd/applications/bitwarden/secrets.yaml

### Deploy applications

```
kubectl apply -f applications.yaml
```

### Cluster shutdown

```
talosctl -n 192.168.0.138 -n 192.168.0.168 -n 192.168.0.226 shutdown
```
