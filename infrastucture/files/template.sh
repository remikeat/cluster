#!/bin/sh
git archive --remote=$ARGOCD_ENV_REPO_URL $ARGOCD_ENV_REPO_REVISION:$ARGOCD_ENV_REPO_PATH $ARGOCD_ENV_VALUES | tar -x
helm template $ARGOCD_ENV_ARGS -f $ARGOCD_ENV_SECRETS -n $ARGOCD_APP_NAMESPACE $ARGOCD_APP_NAME .
