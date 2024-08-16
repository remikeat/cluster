#!/bin/sh
REPO_URL=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_url").value')
REPO_REVISION=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_revision").value')
REPO_PATH=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "repo_path").value')
VALUES=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "values").value')
ARGS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "args").value')
SECRETS=$(echo "$ARGOCD_APP_PARAMETERS" | jq -r '.[] | select(.name == "secrets").value')
git archive --remote=$REPO_URL $REPO_REVISION:$REPO_PATH $VALUES | tar -x
helm template $ARGS -f $SECRETS -n $ARGOCD_APP_NAMESPACE $ARGOCD_APP_NAME .
