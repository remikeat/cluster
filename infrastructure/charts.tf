resource "helm_release" "cilium" {
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"

  values = [
    file("${path.module}/values/cilium-values.yaml")
  ]
}

resource "time_sleep" "wait_few_seconds" {
  depends_on = [helm_release.cilium]

  create_duration = "10s"
}

resource "helm_release" "tailscale" {
  name             = "tailscale"
  namespace        = "tailscale"
  repository       = "https://pkgs.tailscale.com/helmcharts"
  chart            = "tailscale-operator"
  create_namespace = false

  values = [
    templatefile("${path.module}/values/tailscale-values.yaml", {
      clientId     = var.clientId,
      clientSecret = var.clientSecret
    })
  ]

  depends_on = [kubectl_manifest.ippool, kubectl_manifest.l2advertisement, kubernetes_namespace.tailscale]
}

resource "helm_release" "argo-cd" {
  name             = "argo-cd"
  namespace        = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = false

  values = [
    file("${path.module}/values/argo-cd-values.yaml")
  ]

  depends_on = [helm_release.tailscale, kubernetes_config_map.git_askpass, kubernetes_config_map.template, kubernetes_config_map.values]
}
