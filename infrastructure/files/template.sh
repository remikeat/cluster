#!/bin/bash

if [ -f "Chart.yaml" ]; then
    cmd=(helm template)

    SECRETS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "secrets").string')
    if [ -n "$SECRETS" ]; then
        cmd+=(-f bw-secrets/$SECRETS)
    fi

    REPO_VALUES=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_values").string')
    if [ -n "$REPO_VALUES" ]; then
        cmd+=(-f custom_values.yaml)
    fi

    ARGS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "args").string')
    cmd+=($ARGS)

    cmd+=(-n $ARGOCD_APP_NAMESPACE $ARGOCD_APP_NAME .)

    "${cmd[@]}"
elif [ -f "kustomization.yaml" ]; then
    kustomize build
else
    >&2 echo "Neither Chart.yaml nor kustomization.yaml found."
fi
