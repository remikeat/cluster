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

- kv/data/sendgrid#smtp_password

- kv/data/crowdsec#agent_password
- kv/data/crowdsec#enroll_key
- kv/data/crowdsec#bouncer_key

- kv/data/falco#password

- kv/data/elastic#password

- kv/data/kubevirt-manager#htpasswd

- kv/data/redmine#password
- kv/data/redmine#db_password

- kv/data/supabase#anon_key
- kv/data/supabase#service_key
- kv/data/supabase#secret
- kv/data/supabase#password
- kv/data/supabase#db_password
- kv/data/supabase#analytics_api_key

- kv/data/vm#password
- kv/data/vm#pub_key
