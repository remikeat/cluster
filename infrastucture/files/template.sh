#!/bin/sh

if [ -f "Chart.yaml" ]; then
    REPO_URL=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_url").string')
    REPO_REVISION=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_revision").string')
    REPO_PATH=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_path").string')
    VALUES=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "values").string')
    ARGS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "args").string')
    SECRETS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "secrets").string')
    git archive --remote=$REPO_URL $REPO_REVISION:$REPO_PATH $VALUES | tar -x
    helm template $ARGS -f $SECRETS -n $ARGOCD_APP_NAMESPACE $ARGOCD_APP_NAME .
elif [ -f "kustomization.yaml" ]; then
    kustomize build
else
    >&2 echo "Neither Chart.yaml nor kustomization.yaml found."
fi
