resource "kubernetes_config_map" "git_askpass" {
  metadata {
    name      = "git-askpass"
    namespace = "argo-cd"
  }

  data = {
    "git_askpass.sh" = "${file("${path.module}/files/git_askpass.sh")}"
  }
}

resource "kubernetes_config_map" "template" {
  metadata {
    name      = "template"
    namespace = "argo-cd"
  }

  data = {
    "template.sh" = "${file("${path.module}/files/template.sh")}"
  }
}

resource "kubernetes_config_map" "values" {
  metadata {
    name      = "values"
    namespace = "argo-cd"
  }

  data = {
    "values.sh" = "${file("${path.module}/files/values.sh")}"
  }
}
