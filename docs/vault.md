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

## Items

- kv/data/crowdsec#agent_password
- kv/data/crowdsec#enroll_key
- kv/data/crowdsec#bouncer_key
- kv/data/crowdsec#smtp_password

- kv/data/falco#password
