#!/bin/env python
import subprocess
import json
import re

env_file = '.env'


def load_env_file(filename):
    secret_values = {}
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                key, value = line.split('=', 1)
                secret_values[key] = value
    return secret_values


secret_values = load_env_file(env_file)


def generate_password(key="password", length=32):
    result = subprocess.run(['openssl', 'rand', '-base64', str(length)],
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode == 0:
        return {key: result.stdout.decode().strip().replace("\n", "").replace("=", "").replace("/", "")}
    else:
        print(f"Error generating password: {result.stderr.decode()}")
        return {}


def generate_yaml_credentials(username_path, password_path, user="user"):
    username = secret_values.get(username_path, "admin")
    password = secret_values.get(
        password_path, generate_password()["password"])
    return {user: f'username: "{username}"\npassword: "{password}"'}


def split_cert_and_key(cert_and_key_content):
    cert_pattern = r"(-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----)"
    key_pattern = r"(-----BEGIN PRIVATE KEY-----.*?-----END PRIVATE KEY-----)"

    certificate_match = re.search(
        cert_pattern, cert_and_key_content, re.DOTALL)
    private_key_match = re.search(key_pattern, cert_and_key_content, re.DOTALL)

    certificate = certificate_match.group(
        1).strip() if certificate_match else None
    private_key = private_key_match.group(
        1).strip() if private_key_match else None

    return certificate, private_key


def generate_certificate(subj, certificate="certificate", private_key="private_key", days=1095):
    command = (
        "openssl req -new -x509 -nodes -newkey ec:<(openssl ecparam -name secp384r1) "
        "-keyout /dev/stdout -out /dev/stdout -days {} -subj '{}'".format(
            days, subj)
    )

    result = subprocess.run(command, shell=True, executable='/bin/bash',
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode == 0:
        cert_and_key = result.stdout.decode().strip()
        cert, key = split_cert_and_key(cert_and_key)
        return {
            certificate: cert,
            private_key: key
        }
    else:
        print(f"Error generating certificate: {result.stderr.decode()}")
        return {}


def generate_htpasswd(username_path, password_path):
    username = secret_values.get(username_path, "admin")
    password = secret_values.get(
        password_path, generate_password()["password"])
    print(f"Generated password for htpasswd: '{password}'")

    result = subprocess.run(
        ['htpasswd', '-nb', username, password],
        input=password.encode(), stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )

    if result.returncode == 0:
        return {'htpasswd': result.stdout.decode().strip()}
    else:
        print(
            f"Error generating htpasswd for {username}: {result.stderr.decode()}")
        return {}


def secret_exists(path):
    result = subprocess.run(['vault', 'kv', 'get', '--mount=kv', path],
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return result.returncode == 0


def add_secret_to_vault(path, secret_payload):
    json_payload = json.dumps(secret_payload)
    process = subprocess.Popen(
        ['vault', 'kv', 'put', '-mount=kv', path, '-'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )

    _, stderr = process.communicate(input=json_payload)
    if process.returncode != 0:
        print(f"Error adding secret to Vault at {path}: {stderr}")
    return process.returncode == 0


def handle_secret_generation(path, value):
    secret_payload = {}
    for secret_key in value:
        if callable(secret_key):
            generated_secrets = secret_key()
            secret_payload.update(generated_secrets)
        else:
            secret_value = secret_values.get(
                f"{path}/{secret_key}", generate_password()["password"])
            if secret_value is None:
                print(
                    f"Error: No valid value generated for {path}/{secret_key}")
            else:
                secret_payload[secret_key] = secret_value
    return secret_payload


def process_secrets(path_prefix, secrets):
    for key, value in secrets.items():
        if isinstance(value, dict):
            new_path = f"{path_prefix}/{key}"
            process_secrets(new_path, value)
        else:
            path = f"{path_prefix}/{key}"

            if not secret_exists(path):
                print(f"Adding secret: {path}")

                secret_payload = handle_secret_generation(
                    path, value)

                if not add_secret_to_vault(path, secret_payload):
                    print(f"Error occurred while adding: {path}")


SECRETS = {
    "sendgrid": [
        "smtp_password"
    ],
    "ghcr": [
        lambda: generate_yaml_credentials(
            "infra/ghcr/username", "infra/ghcr/password")
    ],
    "github": [
        "username",
        "password"
    ],
    "common": [
        "email",
        "domain",
        "tailnet"
    ],
    "core": {
        "kong": [
            lambda: generate_certificate('/CN=kong_clustering'),
            "password",
            "client_id",
            "client_secret",
            "ip",
            "proxy_ip"
        ],
        "istio": [
            "gateway_ip"
        ],
        "keycloak": [
            "hostname",
            "password",
            "pg_password"
        ],
        "open-appsec": [
            "email",
            "token"
        ],
    },
    "storage": {
        "harbor": [
            "hostname",
            lambda: generate_yaml_credentials(
                "infra/storage/harbor/username", "infra/storage/harbor/password"),
            lambda: generate_yaml_credentials(
                "infra/storage/harbor/registry/username", "infra/storage/harbor/registry/password", "registry_user"),
            "db_password",
            "secret_key"
        ],
        "rook-ceph": [
            "object_access_key",
            "object_secret_key"
        ],
        "cloudnativepg": [
            "pg_backup_access_key",
            "pg_backup_secret_key"
        ],
        "minio": [
            "secret_key",
            "kes-id",
            "kes-secret"
        ],
        "pgadmin": [
            "password"
        ],
        "redis": [
            "password"
        ]
    },
    "monitoring": {
        "crowdsec": [
            "agent_password",
            "enroll_key",
            "bouncer_key"
        ],
        "falco": [
            "password"
        ],
        "elastic": [
            "password"
        ],
        "grafana": [
            "password"
        ],
        "kubeclarity": [
            "db_password"
        ]
    },
    "pipelines": {
        "argo-workflows": [
            "pg_password",
            "client_id",
            "client_secret",
            "access_key",
            "secret_key"
        ]
    },
    "vm": {
        "kubevirt-manager": [
            lambda: generate_htpasswd(
                "infra/vm/kubevirt-manager/username", "infra/vm/kubevirt-manager/password")
        ]
    },
    "apps": {
        "supabase": [
            "hostname",
            "anon_key",
            "service_key",
            "secret",
            "password",
            "db_password",
            "analytics_api_key"
        ],
        "strapi": [
            "db_password",
            "app_keys",
            "api_token_salt",
            "admin_jwt_secret",
            "transfer_token_salt",
            "jwt_secret"
        ],
        "directus": [
            "mariadb_root_password",
            "mariadb_replication_password",
            "mariadb_password",
            "admin_password",
            "key",
            "secret",
            "redis_password"
        ]
    }
}

process_secrets("infra", SECRETS)
