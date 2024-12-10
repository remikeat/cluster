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
talosctl apply-config --insecure -n 192.168.0.122 --file controlplane.yaml
talosctl bootstrap
talosctl kubeconfig
```

### Approve certificates

```
kubectl get csr
kubectl certificate approve csr-xxxxx
```

### Terraform installation

Create a github token with repo permission: https://github.com/settings/tokens
Create a tailscale OAuth client: https://login.tailscale.com/admin/settings/oauth
Create the tailscale OAuth client with Devices Core and Auth Keys write scopes, and the tag tag:k8s-operator
Leave the vault token empty at first and after initializating and unsealing the vault reapply terraform

Create a `.env` file with the following content in terraform folder

```
export TF_VAR_kube_config_path=''
export TF_VAR_external_cidr=''
export TF_VAR_github_repo=''
export TF_VAR_github_username=''
export TF_VAR_github_token=''
export TF_VAR_clientId=''
export TF_VAR_clientSecret=''
export TF_VAR_vault_token=''
```

```
cd terraform
terraform init
source .env
terraform apply -auto-approve
```

Might need to run once more as the CRDs are not ready yet

## Vault

### Init and unseal

```
kubectl exec -it -n vault pods/vault-0 -- vault operator init
kubectl exec -it -n vault pods/vault-0 -- vault operator unseal
```

### Update token

Update token in terraform .env file and apply terraform one more time

```
cd terraform
source .env
terraform apply -auto-approve
```

### Restart argocd

```
kubectl -n argocd rollout restart deployment argocd-server
kubectl -n argocd rollout restart deployment argocd-repo-server
```

### Add secrets

```
vault login
```

### Enable kv secrets

```
vault secrets enable -version=2 kv
```

### Enable AppRole auth

```
vault auth enable approle
```

### Create policy

```
vault policy write kes-policy kes-policy.hcl
```

### Create role

```
vault write auth/approle/role/kes-role token_num_uses=0 secret_id_num_uses=0 period=5m
vault write auth/approle/role/kes-role policies=kes-policy
```

### Retrieve secret

```
vault read auth/approle/role/kes-role/role-id
vault write -f auth/approle/role/kes-role/secret-id
```

Generate secrets for supabase using this page:
https://supabase.com/docs/guides/self-hosting/docker

Create .env file in vault folder with below content

```
infra/sendgrid/smtp_password=
infra/ghcr/username=
infra/ghcr/password=
infra/github/username=
infra/github/password=
infra/common/email=
infra/common/domain=
infra/core/kong/ip=
infra/core/kong/client_id=
infra/core/kong/client_secret=
infra/core/keycloak/hostname=
infra/core/open-appsec/email=
infra/core/open-appsec/token=
infra/storage/harbor/hostname=
infra/storage/harbor/username=
infra/storage/harbor/registry/username=
infra/storage/rook-ceph/object_access_key=
infra/storage/cloudnativepg/pg_backup_access_key=
infra/storage/minio/kes-id=
infra/storage/minio/kes-secret=
infra/monitoring/crowdsec/enroll_key=
infra/monitoring/elastic/password=
infra/pipelines/argo-workflows/client_id=
infra/pipelines/argo-workflows/client_secret=
infra/pipelines/argo-workflows/acess_key=
infra/vm/kubevirt-manager/username=
infra/vm/kubevirt-manager/password=
infra/apps/supabase/hostname=
infra/apps/supabase/anon_key=
infra/apps/supabase/service_key=
infra/apps/supabase/secret=
infra/apps/supabase/analytics_api_key=
```

```
cd vault
./add_secrets.py
```

## Initial configuration (after terraform)

### Create applications

```
cd argocd
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
