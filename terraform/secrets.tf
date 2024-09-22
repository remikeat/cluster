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

resource "kubernetes_secret" "github_https" {
  metadata {
    name      = "github-https"
    namespace = "argocd"
  }

  data = {
    username = "remikeat"
    password = var.github_token
  }

  type = "kubernetes.io/basic-auth"

  depends_on = [kubernetes_namespace.argocd]
}

resource "kubernetes_secret" "github_registry" {
  metadata {
    name      = "github-registry"
    namespace = "argocd"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "ghcr.io" = {
          "username" = "remikeat"
          "password" = var.registry_password
          "auth"     = base64encode("remikeat:${var.registry_password}")
        }
      }
    })
  }

  depends_on = [kubernetes_namespace.argocd]
}

resource "kubernetes_secret" "bt_auth_token" {
  metadata {
    name      = "bw-auth-token"
    namespace = "argocd"
  }

  data = {
    token = var.bitwarden_token
  }

  depends_on = [kubernetes_namespace.argocd]
}
