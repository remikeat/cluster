# Instalation

## CLI tools installation

```
cd misc
ansible-playbook install_cli_tools.yml -K
```

## Talos installation

- Download talos image from https://factory.talos.dev/ by setting values according to talos/boot_assets/assets.yaml

```
cd talos/boot_assets
./get_boot_assets_id.sh
```

### Flash image (installation with bootable usb drive)

Flash the iso image (metal-amd64.iso) with balenaEtcher (https://www.balena.io/)

### Or flash disk image directly (SBC)

Extract the image

```
xz -d metal-arm64.raw.xz
```

Check carefully which drive to flash with

```
sudo lsblk
```

Flash the image

```
sudo dd if=metal-arm64.raw of=DEVICE_TO_FLASH conv=fsync bs=4M
```

### Apply configuration

Generate a auth key for tailscale

https://login.tailscale.com/admin/settings/keys

Generate a personal access token

https://app.docker.com/settings/personal-access-tokens

Add those tokens to below files

- registries.yaml
- tailscale.yaml

Generate secrets

```
cd talos
talosctl gen secrets -o secrets.yaml
```

Generate config files

```
./gen_machine_config.sh
```

Prepare the cluster

```
cp talosconfig ~/.talos/config
talosctl config endpoint 192.168.0.122
talosctl config nodes 192.168.0.122
talosctl apply-config --insecure --file controlplane.yaml
talosctl bootstrap
talosctl kubeconfig
```

### Approve certificates

```
kubectl get csr
kubectl certificate approve csr-xxxxx
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
kubectl apply --server-side --request-timeout 0 -f core.yaml
kubectl apply --server-side --request-timeout 0 -f storage.yaml
kubectl apply --server-side --request-timeout 0 -f monitoring.yaml
kubectl apply --server-side --request-timeout 0 -f messages.yaml
kubectl apply --server-side --request-timeout 0 -f pipelines.yaml
kubectl apply --server-side --request-timeout 0 -f vm.yaml
kubectl apply --server-side --request-timeout 0 -f apps.yaml
```

### Configuation

Make sure harbor project is private

Create account for strapi

Change password of emqx dashboard IMMEDIATELY

EMQX dashboard initial credentials:

- username: admin
- password: public
