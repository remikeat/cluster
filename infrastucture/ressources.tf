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
