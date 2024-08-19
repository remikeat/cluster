#!/bin/bash

if [ -f "Chart.yaml" ]; then
    cmd=(helm template)
    REPO_URL=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_url").string')
    REPO_REVISION=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_revision").string')
    REPO_VALUES=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_values").string')
    if [ -n "$VALUES" ]; then
        git clone $REPO_URL custom_values
        cd custom_values
        git checkout $REPO_REVISION
        cd -
        cmd+=(-f custom_values/$REPO_VALUES)
    fi

    ARGS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "args").string')
    SECRETS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "secrets").string')
    if [ -n "$SECRETS" ]; then
        cmd+=(-f bw-secrets/$SECRETS)
    fi
    cmd+=(-n $ARGOCD_APP_NAMESPACE $ARGOCD_APP_NAME .)
    "${cmd[@]}"
elif [ -f "kustomization.yaml" ]; then
    kustomize build
else
    >&2 echo "Neither Chart.yaml nor kustomization.yaml found."
fi
