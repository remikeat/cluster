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

- kv/data/infra/sendgrid#smtp_password

- kv/data/infra/crowdsec#agent_password
- kv/data/infra/crowdsec#enroll_key
- kv/data/infra/crowdsec#bouncer_key

- kv/data/infra/falco#password

- kv/data/infra/elastic#password

- kv/data/infra/kubevirt-manager#htpasswd

- kv/data/infra/supabase#anon_key
- kv/data/infra/supabase#service_key
- kv/data/infra/supabase#secret
- kv/data/infra/supabase#password
- kv/data/infra/supabase#db_password
- kv/data/infra/supabase#analytics_api_key

- kv/data/infra/grafana#password

- kv/data/infra/ghcr#user

- kv/data/infra/harbor#user
- kv/data/infra/harbor#registry_user
- kv/data/infra/harbor#db_password
- kv/data/infra/harbor#secret_key

- kv/data/infra/kubeclarity#db_password

- kv/data/infra/rook-ceph#object_access_key
- kv/data/infra/rook-ceph#object_secret_key

- kv/data/infra/cloudnativepg#pg_backup_access_key
- kv/data/infra/cloudnativepg#pg_backup_secret_key

- kv/data/infra/minio#secret_key
- kv/data/infra/minio#kes-id
- kv/data/infra/minio#kes-secret

- kv/data/infra/kong#certificate
- kv/data/infra/kong#private_key
- kv/data/infra/kong#password
- kv/data/infra/kong#client_id
- kv/data/infra/kong#client_secret
- kv/data/infra/kong#ip

- kv/data/infra/keycloak#password
- kv/data/infra/keycloak#pg_password

- kv/data/infra/pgadmin#password

- kv/data/infra/open-appsec#email
- kv/data/infra/open-appsec#token

- kv/data/infra/argo-workflows#pg_password
- kv/data/infra/argo-workflows#client_id
- kv/data/infra/argo-workflows#client_secret
- kv/data/infra/argo-workflows#access_key
- kv/data/infra/argo-workflows#secret_key

- kv/data/infra/github#username
- kv/data/infra/github#password

- kv/data/infra/redis#password

<!-- - kv/data/infra/rabbitmq#username
- kv/data/infra/rabbitmq#password -->

### Container registry

- kv/data/infra/ghcr#user

- kv/data/infra/harbor#user
- kv/data/infra/harbor#registry_user

Value should be

```
username: ""
password: ""
```
