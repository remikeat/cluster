resource "helm_release" "cilium" {
  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"

  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }
  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent"
    value = "{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}"
  }
  set {
    name  = "securityContext.capabilities.cleanCiliumState"
    value = "{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}"
  }
  set {
    name  = "cgroup.autoMount.enabled"
    value = "false"
  }
  set {
    name  = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }
  set {
    name  = "k8sServiceHost"
    value = "localhost"
  }
  set {
    name  = "k8sServicePort"
    value = "7445"
  }
  set {
    name  = "l2announcements.enabled"
    value = "true"
  }
  set {
    name  = "externalIPs.enabled"
    value = "true"
  }
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

  depends_on = [helm_release.cilium, kubectl_manifest.ippool, kubectl_manifest.l2advertisement]
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
  repository       = "https://releases.rancher.com/server-charts/latest"
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

resource "helm_release" "argo-cd" {
  name             = "argo-cd"
  namespace        = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true

  set {
    name  = "global.domain"
    value = "argocd.remikeat.com"
  }

  set {
    name  = "configs.params.server.insecure"
    value = true
  }

  set {
    name  = "server.ingress.enabled"
    value = true
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "server.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-production"
  }

  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
    value = "false"
  }

  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/backend-protocol"
    value = "HTTPS"
  }

  set {
    name  = "server.ingress.extraTls[0].hosts[0]"
    value = "argocd.remikeat.com"
  }

  set {
    name  = "server.ingress.extraTls[0].secretName"
    value = "argocd-tls"
  }

  depends_on = [helm_release.cert-manager]
}

# resource "helm_release" "longhorn" {
#   name             = "longhorn"
#   namespace        = "longhorn"
#   repository       = "https://charts.longhorn.io"
#   chart            = "longhorn"
#   create_namespace = true

#   depends_on = [helm_release.cert-manager]
# }

# resource "helm_release" "kube-prometheus-stack" {
#   name             = "kube-prometheus-stack"
#   namespace        = "kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "kube-prometheus-stack"
#   create_namespace = true

#   depends_on = [helm_release.cert-manager]

#   set {
#     name  = "prometheus.prometheusSpec.scrapeInterval"
#     value = "30s"
#   }
#   set {
#     name  = "prometheus.prometheusSpec.evaluationInterval"
#     value = "30s"
#   }
#   set {
#     name  = "grafana.adminPassword"
#     value = var.grafana_password
#   }
# }

# resource "helm_release" "actions-runner-controller" {
#   name             = "actions-runner-controller"
#   namespace        = "actions-runner-controller"
#   repository       = "https://actions-runner-controller.github.io/actions-runner-controller"
#   chart            = "actions-runner-controller"
#   create_namespace = true

#   depends_on = [helm_release.cert-manager]

#   set {
#     name  = "authSecret.create"
#     value = true
#   }
#   set {
#     name  = "authSecret.github_token"
#     value = var.github_token
#   }
# }
