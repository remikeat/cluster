resource "helm_release" "calico" {
  name             = "calico"
  namespace        = "calico"
  repository       = "https://docs.tigera.io/calico/charts"
  chart            = "tigera-operator"
  create_namespace = true
}
