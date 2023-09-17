variable "config_path" {
  description = "Kube config file"
  type        = string
}

variable "anonKey" {
  description = "Anon Key"
  type        = string
}

variable "serviceKey" {
  description = "Service Key"
  type        = string
}

variable "secret" {
  description = "Secret"
  type        = string
}

variable "email" {
  description = "Email"
  type        = string
}

variable "smtp_password" {
  description = "SMTP password"
  type        = string
}

variable "db_username" {
  description = "DB username"
  type        = string
}

variable "db_password" {
  description = "DB password"
  type        = string
}
