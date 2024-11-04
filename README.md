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

### Create applications

```
kubectl apply -f applicationset.yaml
kubectl apply -f applications.yaml
```

### Configuation

Make sure harbor project is private

Change password of emqx dashboard IMMEDIATELY

EMQX dashboard initial credentials:

- username: admin
- password: public
