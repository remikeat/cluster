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

  create_duration = "5s"
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true

  values = [
    templatefile("${path.module}/values/ingress-nginx-values.yaml", {
      crowdsec_api_key = var.crowdsec_api_key
    })
  ]

  depends_on = [helm_release.cilium, kubectl_manifest.ippool, kubectl_manifest.l2advertisement]
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true

  values = [
    file("${path.module}/values/cert-manager-values.yaml")
  ]

  depends_on = [helm_release.ingress-nginx]
}

resource "helm_release" "rancher" {
  name             = "rancher"
  namespace        = "rancher"
  repository       = "https://releases.rancher.com/server-charts/latest"
  chart            = "rancher"
  create_namespace = true

  values = [
    templatefile("${path.module}/values/rancher-values.yaml", {
      hostname          = var.hostname,
      bootstrapPassword = var.bootstrapPassword,
      email             = var.email
    })
  ]

  depends_on = [helm_release.cert-manager]
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

  depends_on = [helm_release.cert-manager, kubernetes_config_map.git_askpass, kubernetes_config_map.template, kubernetes_config_map.values]
}
