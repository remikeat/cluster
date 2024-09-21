resource "kubernetes_namespace" "argo-cd" {
  metadata {
    name = "argo-cd"
  }
}

resource "kubernetes_namespace" "tailscale" {
  metadata {
    name = "tailscale"
    labels = {
      "pod-security.kubernetes.io/enforce"         = "privileged"
      "pod-security.kubernetes.io/enforce-version" = "latest"
    }
  }
}


resource "kubernetes_config_map" "git_askpass" {
  metadata {
    name      = "git-askpass"
    namespace = "argo-cd"
  }

  data = {
    "git_askpass.sh" = "${file("${path.module}/files/git_askpass.sh")}"
  }

  depends_on = [kubernetes_namespace.argo-cd]
}

resource "kubernetes_config_map" "template" {
  metadata {
    name      = "template"
    namespace = "argo-cd"
  }

  data = {
    "template.py" = "${file("${path.module}/files/template.py")}"
  }

  depends_on = [kubernetes_namespace.argo-cd]
}

resource "kubernetes_config_map" "values" {
  metadata {
    name      = "values"
    namespace = "argo-cd"
  }

  data = {
    "values.py" = "${file("${path.module}/files/values.py")}"
  }

  depends_on = [kubernetes_namespace.argo-cd]
}
