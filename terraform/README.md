# Setup

Create github tokens: https://github.com/settings/tokens
Create tailscale OAuth clients: https://login.tailscale.com/admin/settings/oauth

Create a `.env` file with the following content

```
export TF_VAR_github_token=''
export TF_VAR_clientId=''
export TF_VAR_clientSecret=''
```

# Run

```
terraform init
source .env
terraform apply
```
