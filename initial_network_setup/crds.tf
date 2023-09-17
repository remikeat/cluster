resource "kubectl_manifest" "bgpconfiguration" {
  yaml_body  = <<-EOF
apiVersion: crd.projectcalico.org/v1
kind: BGPConfiguration
metadata:
  name: default
spec:
  serviceLoadBalancerIPs:
    - cidr: "${var.external_cidr}"
  EOF
  depends_on = [helm_release.calico]
}
