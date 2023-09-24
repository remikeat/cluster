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

# How to encode in base64

```
echo -n "username:password" | base64
```

# Run

```
kubectl kustomize . | kubectl apply -f-
```
