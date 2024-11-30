resource "helm_release" "cilium" {
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"

  values = [
    file("${path.module}/values/cilium-values.yaml")
  ]
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

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = false

  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]

  depends_on = [helm_release.tailscale]
}

resource "helm_release" "vault" {
  name             = "vault"
  namespace        = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  create_namespace = true

  values = [
    file("${path.module}/values/vault-values.yaml")
  ]

  depends_on = [helm_release.argocd]
}
