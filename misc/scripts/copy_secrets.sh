#!/bin/bash

ROOT_PATH="/"
SUBPATH="/infra"

copy_secrets() {
    local current_path="$1"
    local secrets=$(vault kv list --mount=kv -format=json "$current_path" | jq -r '.[]')

    for secret in $secrets; do
        if [[ "$secret" == */ ]]; then
            copy_secrets "$current_path$secret"
        else
            data=$(vault kv get --mount=kv -format=json "$current_path$secret" | jq -r '.data.data')

            vault_args=()
            for key in $(echo "$data" | jq -r 'keys[]'); do
                value=$(echo "$data" | jq -r --arg key "$key" '.[$key]')
                vault_args+=("$key=$value")
            done

            echo "Copying secret $current_path$secret to $SUBPATH$current_path$secret"
            vault kv put --mount=kv "$SUBPATH$current_path$secret" "${vault_args[@]}"
        fi
    done
}

copy_secrets "$ROOT_PATH"
echo "Secrets have been copied from $ROOT_PATH to $SUBPATH."
