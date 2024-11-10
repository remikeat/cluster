resource "kubernetes_secret" "private_repo" {
  metadata {
    name      = "repo-cluster"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type     = "git"
    project  = "default"
    url      = "https://github.com/remikeat/cluster"
    username = "remikeat"
    password = var.github_token
  }
  depends_on = [kubernetes_namespace.argocd]
}

resource "kubernetes_secret" "vault_configuration" {
  metadata {
    name      = "vault-configuration"
    namespace = "argocd"
  }

  data = {
    VAULT_ADDR    = "http://vault.vault.svc.cluster.local:8200"
    AVP_TYPE      = "vault"
    AVP_AUTH_TYPE = "token"
    VAULT_TOKEN   = var.vault_token
  }

  depends_on = [kubernetes_namespace.argocd]
}
