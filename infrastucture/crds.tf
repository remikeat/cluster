resource "kubectl_manifest" "ippool" {
  yaml_body  = <<-EOF
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: "pool"
spec:
  blocks:
  - cidr: "${var.external_cidr}"
  allowFirstLastIPs: "No"
  EOF
  depends_on = [helm_release.cilium]
}

resource "kubectl_manifest" "l2advertisement" {
  yaml_body  = <<-EOF
apiVersion: "cilium.io/v2alpha1"
kind: CiliumL2AnnouncementPolicy
metadata:
  name: l2announcement-policy
spec:
  externalIPs: true
  loadBalancerIPs: true
  EOF
  depends_on = [helm_release.cilium]
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
