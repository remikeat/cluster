resource "kubernetes_config_map" "git_askpass" {
  metadata {
    name      = "git-askpass"
    namespace = "argo-cd"
  }

  data = {
    "git_askpass.sh" = "${file("${path.module}/files/git_askpass.sh")}"
  }
}

resource "kubernetes_config_map" "cmp_plugin" {
  metadata {
    name      = "cmp-plugin"
    namespace = "argo-cd"
  }

  data = {
    "template.sh" = "${file("${path.module}/files/template.sh")}"
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
