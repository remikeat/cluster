# Setup

Create a `.env` file with the following content

```
export TF_VAR_bootstrapPassword=''
export TF_VAR_github_token=''
export TF_VAR_bitwarden_token=''
export TF_VAR_crowdsec_api_key=''
export TF_VAR_registry_username=''
export TF_VAR_registry_password=''
```

# Run

```
terraform init
source .env
terraform apply
```
