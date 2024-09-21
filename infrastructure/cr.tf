resource "kubectl_manifest" "ippool" {
  yaml_body = templatefile("${path.module}/manifests/ippool.yaml", {
    external_cidr = var.external_cidr
  })
  depends_on = [time_sleep.wait_few_seconds]
}

resource "kubectl_manifest" "l2advertisement" {
  yaml_body  = file("${path.module}/manifests/l2advertisement.yaml")
  depends_on = [time_sleep.wait_few_seconds]
}
