# Introduction

Landing page: https://diy-cloud.remikeat.com/

This repository contains the Infrastructure as Code to deploy a single node kubernetes cluster with below software

| Category       | Component                 | Rough AWS equivalent                    |
| -------------- | ------------------------- | --------------------------------------- |
| **apps**       | directus                  |                                         |
|                | strapi                    |                                         |
|                | supabase                  | AWS Amplify                             |
| **core**       | cert-manager              | AWS Certificate Manager (ACM)           |
|                | descheduler               |                                         |
|                | external-secrets          | AWS Secrets Manager                     |
|                | istio                     | AWS App Mesh                            |
|                | keycloak                  | Amazon Cognito                          |
|                | kong                      | Amazon API Gateway                      |
|                | rancher                   | AWS Console                             |
| **dev**        | debug                     |                                         |
|                | telepresence              |                                         |
| **messages**   | emqx                      | AWS IoT Core                            |
|                | kafka                     | Amazon MSK (Managed Kafka Service)      |
|                | kafka-ui                  | Amazon MSK Management Console           |
|                | rabbitmq                  | Amazon MQ                               |
| **monitoring** | crowdsec                  | AWS GuardDuty                           |
|                | elastic                   | Amazon OpenSearch Service               |
|                | falco                     | AWS CloudTrail                          |
|                | fluent                    | Amazon Kinesis Data Firehose            |
|                | grafana                   | Amazon Managed Grafana                  |
|                | jaeger                    | AWS X-Ray                               |
|                | kiali                     | AWS App Mesh Visualizer                 |
|                | kubeclarity               |                                         |
|                | metrics-server            | Amazon CloudWatch                       |
|                | open-telemetry            | AWS Distro for OpenTelemetry (ADOT)     |
|                | trivy                     | AWS Inspector                           |
| **pipelines**  | argo-workflows            | AWS Step Functions                      |
|                | camel-k                   |                                         |
|                | knative                   | AWS Lambda                              |
|                | tekton                    | AWS CodePipeline                        |
|                | tekton-pipelines          | AWS CodePipeline                        |
| **storage**    | cloudnativepg             | Amazon RDS (PostgreSQL engine)          |
|                | harbor                    | Amazon Elastic Container Registry (ECR) |
|                | local-path-provisioner    |                                         |
|                | mariadb                   | Amazon RDS (MariaDB engine)             |
|                | minio                     | Amazon S3                               |
|                | mongodb                   | Amazon DocumentDB                       |
|                | pgadmin                   | AWS RDS Management Console              |
|                | redis                     | Amazon ElastiCache                      |
|                | redis-insight             | Amazon ElastiCache Management Console   |
|                | rook-ceph                 | Amazon S3 / EBS                         |
| **vm**         | external-snapshotter      |                                         |
|                | harvester                 | Amazon EC2                              |
|                | kubevirt                  | Amazon EC2                              |
|                | kubevirt-manager          | Amazon EC2 Management Console           |
|                | multus                    |                                         |
|                | system-upgrade-controller |                                         |

It is using

- ArgoCD for gitops
- terraform to deploy the base components
- talos linux as a k8s linux distribution

Terraform is deploying

- cilium (as a CNI)
- longhorn (block storage)
- vault (Hashicorp)
- tailscale (for ingresses)
- argocd (for gitops)

# Minimum requirements

To have all the components running

- CPU: 16 cores
- Memory: 64GB

## Accounts

### Needed

- https://tailscale.com/

### Optional

- https://app.crowdsec.net/
- https://www.getambassador.io/

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
./gen_machine_config.sh NODE_IP_ADDRESS
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

Create a `.env` file in terraform folder and fill the values

```
cd terraform
cp example.env .env
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

Create .env file in vault folder and fill the values

```
cd vault
cp example.env .env
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

# Notes

It seems that argo-vault-plugin is not able to replace templated values if they are keys

So manual remplacement of the value is needed in below file

- argocd/pipelines/knative/kustomize-serving.yaml

```
domain:
    remikeat.com: ""
```
