# Setup

Create a `.env` file with the following content

```
export TF_VAR_bitwarden_token=''
export TF_VAR_github_token=''
export TF_VAR_registry_password=''
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
