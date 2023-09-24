# Setup

Create an `.dockerconfigjson` file with the following content:

```
{
    "auths": {
        "ghcr.io": {
            "username": "",
            "password": "",
            "auth": "username:password base64 encoded"
        }
    }
}
```

Create an `.env` file with the following content:

```
NEXT_PUBLIC_WEB3FORMS_TOKEN=""
NEXT_PUBLIC_HCAPTCHA_TOKEN=""
```

# How to encode in base64

```
echo -n "username:password" | base64
```

# Run

```
kubectl kustomize . | kubectl apply -f-
```
