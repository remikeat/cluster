# Vault

## Create policy

```
vault policy write kes-policy kes-policy.hcl
```

## Create role

```
vault write auth/approle/role/kes-role token_num_uses=0 secret_id_num_uses=0 period=5m
vault write auth/approle/role/kes-role policies=kes-policy
```

## Retrieve secret

```
vault read auth/approle/role/kes-role/role-id
vault write -f auth/approle/role/kes-role/secret-id
```
