# Vault

## Init and unseal

```
kubectl exec -it -n vault pods/vault-0 -- vault operator init
kubectl exec -it -n vault pods/vault-0 -- vault operator unseal
```

## Enable kv secrets

```
vault secrets enable -version=2 kv
```
