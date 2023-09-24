resource "helm_release" "metallb" {
  name             = "metallb"
  namespace        = "metallb"
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  create_namespace = true
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  depends_on = [helm_release.metallb, kubectl_manifest.ipaddresspool, kubectl_manifest.l2advertisement]
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [helm_release.ingress-nginx]
}

resource "helm_release" "rancher" {
  name             = "rancher"
  namespace        = "rancher"
  repository       = "https://releases.rancher.com/server-charts/stable"
  chart            = "rancher"
  create_namespace = true

  set {
    name  = "hostname"
    value = var.hostname
  }
  set {
    name  = "bootstrapPassword"
    value = var.bootstrapPassword
  }
  set {
    name  = "letsEncrypt.email"
    value = var.email
  }
  set {
    name  = "letsEncrypt.ingress.class"
    value = "nginx"
  }
  set {
    name  = "ingress.extraAnnotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-production"
  }
  set {
    name  = "ingress.includeDefaultExtraAnnotations"
    value = false
  }
  set {
    name  = "ingress.ingressClassName"
    value = "nginx"
  }

  depends_on = [helm_release.cert-manager]
}

resource "helm_release" "longhorn" {
  name             = "longhorn"
  namespace        = "longhorn"
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  create_namespace = true

  depends_on = [helm_release.cert-manager]
}

resource "helm_release" "kube-prometheus-stack" {
  name             = "kube-prometheus-stack"
  namespace        = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  create_namespace = true

  depends_on = [helm_release.cert-manager]

  set {
    name  = "prometheus.prometheusSpec.scrapeInterval"
    value = "30s"
  }
  set {
    name  = "prometheus.prometheusSpec.evaluationInterval"
    value = "30s"
  }
  set {
    name  = "grafana.adminPassword"
    value = var.grafana_password
  }
}

resource "helm_release" "actions-runner-controller" {
  name             = "actions-runner-controller"
  namespace        = "actions-runner-controller"
  repository       = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart            = "actions-runner-controller"
  create_namespace = true

  depends_on = [helm_release.cert-manager]

  set {
    name  = "authSecret.create"
    value = true
  }
  set {
    name  = "authSecret.github_token"
    value = var.github_token
  }
}
