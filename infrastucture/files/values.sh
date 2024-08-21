#!/bin/bash

SECRETS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "secrets").string')
if [ -n "$SECRETS" ]; then
    mkdir bw-secrets
    cp /bw-secrets/* ./bw-secrets/
fi

REPO_URL=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_url").string')
REPO_REVISION=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_revision").string')
REPO_VALUES=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_values").string')
if [ -n "$REPO_URL" ]; then
    git clone --quiet $REPO_URL /repo/custom_values
fi
if [ -n "$REPO_REVISION" ]; then
    cd /repo/custom_values
    git checkout --quiet $REPO_REVISION
    cd -
fi
if [ -n "$REPO_VALUES" ]; then
    cp /repo/custom_values/$REPO_VALUES custom_values.yaml
fi
if [ -n "$REPO_URL" ]; then
    rm -rf /repo/custom_values
fi
