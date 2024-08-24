FROM quay.io/argoproj/argocd:v2.12.0

USER root

RUN apt-get update && \
    apt-get install -y \
    curl \
    python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER $ARGOCD_USER_ID
