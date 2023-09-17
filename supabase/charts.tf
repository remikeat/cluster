resource "helm_release" "supabase" {
  name  = "supabase"
  chart = "../submodules/supabase-kubernetes/charts/supabase"

  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [kubernetes_secret.supabase-supabase-jwt, kubernetes_secret.supabase-supabase-smtp, kubernetes_secret.supabase-supabase-db]
}
