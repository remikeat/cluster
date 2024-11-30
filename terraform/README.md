# Setup

Create a github token with repo permission: https://github.com/settings/tokens
Create a tailscale OAuth client: https://login.tailscale.com/admin/settings/oauth
Create the tailscale OAuth client with Devices Core and Auth Keys write scopes, and the tag tag:k8s-operator
Leave the vault token empty at first and after initializating and unsealing the vault reapply terraform

Create a `.env` file with the following content

```
export TF_VAR_github_token=''
export TF_VAR_clientId=''
export TF_VAR_clientSecret=''
export TF_VAR_vault_token=''
```

# Run

```
terraform init
source .env
terraform apply
```
