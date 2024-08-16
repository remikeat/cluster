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
    name      = "bt-auth-token"
    namespace = "argo-cd"
  }

  data = {
    token = var.bitwarden_token
  }
}
