# Setup

Create a `.env` file with the following content

```
export TF_VAR_bootstrapPassword=""
export TF_VAR_github_token=""
export TF_VAR_bitward_token=""
```

# Run

```
terraform init
source .env
terraform apply
```
