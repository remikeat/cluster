# Setup

Create an `.env` file with the following content

```
export TF_VAR_anonKey=""
export TF_VAR_serviceKey=""
export TF_VAR_secret=""
export TF_VAR_smtp_password=""
export TF_VAR_db_password=""
```

# Run

```
terraform init
source .env
terraform apply
```
