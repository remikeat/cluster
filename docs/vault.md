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

## Enable AppRole auth

```
vault auth enable approle
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

- kv/data/grafana#password

- kv/data/ghcr#user

- kv/data/harbor#user
- kv/data/harbor#registry_user
- kv/data/harbor#db_password
- kv/data/harbor#secret_key

- kv/data/kubeclarity#db_password

- kv/data/rook-ceph#object_access_key
- kv/data/rook-ceph#object_secret_key

- kv/data/cloudnativepg#pg-backup-access-key
- kv/data/cloudnativepg#pg-backup-secret-key

- kv/data/minio#secret_key
- kv/data/minio#kes-id
- kv/data/minio#kes-secret

- kv/data/kong#certificate
- kv/data/kong#private_key
- kv/data/kong#pg_password
- kv/data/kong#password
- kv/data/kong#client_id
- kv/data/kong#client_secret

- kv/data/keycloak#password
- kv/data/keycloak#pg_password

- kv/data/pgadmin#password

- kv/data/open-appsec#email
- kv/data/open-appsec#token

<!-- - kv/data/rabbitmq#username
- kv/data/rabbitmq#password -->

### Container registry

- kv/data/ghcr#user

- kv/data/harbor#user
- kv/data/harbor#registry_user

Value should be

```
username: ""
password: ""
```
