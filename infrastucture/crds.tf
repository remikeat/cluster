resource "kubectl_manifest" "ipaddresspool" {
  yaml_body  = <<-EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default
  namespace: metallb
spec:
  addresses:
    - "${var.external_cidr}"
  avoidBuggyIPs: true
  EOF
  depends_on = [helm_release.metallb]
}

resource "kubectl_manifest" "l2advertisement" {
  yaml_body  = <<-EOF
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2advertisement
  namespace: metallb
  EOF
  depends_on = [helm_release.metallb]
}

resource "kubectl_manifest" "letsencrypt_staging" {
  yaml_body  = <<-EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: "${var.email}"
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
      - http01:
          ingress:
            class: nginx
  EOF
  depends_on = [helm_release.cert-manager]
}

resource "kubectl_manifest" "letsencrypt_production" {
  yaml_body  = <<-EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.email}
    privateKeySecretRef:
      name: letsencrypt-production
    solvers:
      - http01:
          ingress:
            class: nginx
  EOF
  depends_on = [helm_release.cert-manager]
}
