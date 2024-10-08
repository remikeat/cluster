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

## Backup vault

```
vault operator raft snapshot save backup.snap
```

## Restore backup

```
vault operator raft snapshot restore backup.snap
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

- kv/data/resume#web3form_token
- kv/data/resume#hcaptcha_token

- kv/data/ghcr#password
- kv/data/ghcr#auth

- kv/data/grafana#password

- kv/data/harbor#password

- kv/data/kubeclarity#db_password

- kv/data/rook-ceph#object_access_key
- kv/data/rook-ceph#object_secret_key
