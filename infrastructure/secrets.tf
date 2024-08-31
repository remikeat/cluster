resource "kubernetes_secret" "private_repo" {
  metadata {
    name      = "repo-cluster"
    namespace = "argo-cd"
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
}

resource "kubernetes_secret" "github_https" {
  metadata {
    name      = "github-https"
    namespace = "argo-cd"
  }

  data = {
    username = var.github_username
    password = var.github_token
  }

  type = "kubernetes.io/basic-auth"
}

resource "kubernetes_secret" "bt_auth_token" {
  metadata {
    name      = "bw-auth-token"
    namespace = "argo-cd"
  }

  data = {
    token = var.bitwarden_token
  }
}

resource "kubernetes_secret" "github_registry" {
  metadata {
    name      = "github-registry"
    namespace = "argo-cd"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "ghcr.io" = {
          "username" = var.registry_username
          "password" = var.registry_password
          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }
}
