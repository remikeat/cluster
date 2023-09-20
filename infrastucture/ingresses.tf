resource "kubernetes_ingress_v1" "grafana-ingress" {
  metadata {
    name      = "grafana"
    namespace = "kube-prometheus-stack"
    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-production"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = var.grafana_url
      http {
        path {
          backend {
            service {
              name = "kube-prometheus-stack-grafana"
              port {
                number = 80
              }
            }
          }

          path = "/"
        }
      }
    }

    tls {
      hosts       = [var.grafana_url]
      secret_name = "grafana-tls"
    }
  }

  depends_on = [helm_release.kube-prometheus-stack]
}
