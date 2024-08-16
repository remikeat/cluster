#!/bin/sh
REPO_URL=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r ' add | .repo_url')
REPO_REVISION=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r ' add | .repo_revision')
REPO_PATH=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r ' add | .repo_path')
VALUES=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r ' add | .values')
ARGS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r ' add | .args')
SECRETS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r ' add | .secrets')
git archive --remote=$REPO_URL $REPO_REVISION:$REPO_PATH $VALUES | tar -x
helm template $ARGS -f $SECRETS -n $ARGOCD_APP_NAMESPACE $ARGOCD_APP_NAME .
