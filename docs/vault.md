# Vault

## Init and unseal

```
kubectl exec -it -n vault pods/vault-0 -- vault operator init
kubectl exec -it -n vault pods/vault-0 -- vault operator unseal
```

## Vault login

```
vault login
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

### Common

- kv/data/infra/sendgrid#smtp_password

- kv/data/infra/ghcr#user

- kv/data/infra/github#username
- kv/data/infra/github#password

- kv/data/infra/common#email

### Core

- kv/data/infra/core/kong#certificate
- kv/data/infra/core/kong#private_key
- kv/data/infra/core/kong#password
- kv/data/infra/core/kong#client_id
- kv/data/infra/core/kong#client_secret
- kv/data/infra/core/kong#ip

- kv/data/infra/core/keycloak#password
- kv/data/infra/core/keycloak#pg_password

- kv/data/infra/core/open-appsec#email
- kv/data/infra/core/open-appsec#token

### Storage

- kv/data/infra/storage/harbor#user
- kv/data/infra/storage/harbor#registry_user
- kv/data/infra/storage/harbor#db_password
- kv/data/infra/storage/harbor#secret_key

- kv/data/infra/storage/rook-ceph#object_access_key
- kv/data/infra/storage/rook-ceph#object_secret_key

- kv/data/infra/storage/cloudnativepg#pg_backup_access_key
- kv/data/infra/storage/cloudnativepg#pg_backup_secret_key

- kv/data/infra/storage/minio#secret_key
- kv/data/infra/storage/minio#kes-id
- kv/data/infra/storage/minio#kes-secret

- kv/data/infra/storage/pgadmin#password

- kv/data/infra/storage/redis#password

### Monitoring

- kv/data/infra/monitoring/crowdsec#agent_password
- kv/data/infra/monitoring/crowdsec#enroll_key
- kv/data/infra/monitoring/crowdsec#bouncer_key

- kv/data/infra/monitoring/falco#password

- kv/data/infra/monitoring/elastic#password

- kv/data/infra/monitoring/grafana#password

- kv/data/infra/monitoring/kubeclarity#db_password

### Pipelines

- kv/data/infra/pipelines/argo-workflows#pg_password
- kv/data/infra/pipelines/argo-workflows#client_id
- kv/data/infra/pipelines/argo-workflows#client_secret
- kv/data/infra/pipelines/argo-workflows#access_key
- kv/data/infra/pipelines/argo-workflows#secret_key

### VM

- kv/data/infra/vm/kubevirt-manager#htpasswd

### Apps

- kv/data/infra/apps/supabase#anon_key
- kv/data/infra/apps/supabase#service_key
- kv/data/infra/apps/supabase#secret
- kv/data/infra/apps/supabase#password
- kv/data/infra/apps/supabase#db_password
- kv/data/infra/apps/supabase#analytics_api_key

- kv/data/infra/apps/strapi#db_password
- kv/data/infra/apps/strapi#app_keys
- kv/data/infra/apps/strapi#api_token_salt
- kv/data/infra/apps/strapi#admin_jwt_secret
- kv/data/infra/apps/strapi#transfer_token_salt
- kv/data/infra/apps/strapi#jwt_secret

- kv/data/infra/apps/directus#mariadb-root-password
- kv/data/infra/apps/directus#mariadb-replication-password
- kv/data/infra/apps/directus#mariadb-password
- kv/data/infra/apps/directus#admin_password
- kv/data/infra/apps/directus#key
- kv/data/infra/apps/directus#secret

<!-- - kv/data/infra/messages/rabbitmq#username
- kv/data/infra/messages/rabbitmq#password -->

### Container registry

- kv/data/infra/ghcr#user

- kv/data/infra/storage/harbor#user
- kv/data/infra/storage/harbor#registry_user

Value should be

```
username: ""
password: ""
```
