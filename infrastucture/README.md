# Setup

Create a `.env` file with the following content

```
export TF_VAR_bootstrapPassword=""
export TF_VAR_github_token=""
```

# Run

```
terraform init
source .env
terraform apply
```
