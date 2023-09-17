resource "kubernetes_secret" "supabase-supabase-jwt" {
  metadata {
    name = "supabase-supabase-jwt"
  }

  data = {
    anonKey    = "${var.anonKey}"
    serviceKey = "${var.serviceKey}"
    secret     = "${var.secret}"
  }
}

resource "kubernetes_secret" "supabase-supabase-smtp" {
  metadata {
    name = "supabase-supabase-smtp"
  }

  data = {
    username = "${var.email}"
    password = "${var.smtp_password}"
  }
}

resource "kubernetes_secret" "supabase-supabase-db" {
  metadata {
    name = "supabase-supabase-db"
  }

  data = {
    username = "${var.db_username}"
    password = "${var.db_password}"
  }
}
