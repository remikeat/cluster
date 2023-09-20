variable "config_path" {
  description = "Kube config file"
  type        = string
}

variable "anonKey" {
  description = "Anon Key"
  type        = string
  sensitive   = true
}

variable "serviceKey" {
  description = "Service Key"
  type        = string
  sensitive   = true
}

variable "secret" {
  description = "Secret"
  type        = string
  sensitive   = true
}

variable "email" {
  description = "Email"
  type        = string
}

variable "smtp_password" {
  description = "SMTP password"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "DB username"
  type        = string
}

variable "db_password" {
  description = "DB password"
  type        = string
  sensitive   = true
}
