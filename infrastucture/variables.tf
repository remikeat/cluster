variable "config_path" {
  description = "Kube config file"
  type        = string
}

variable "email" {
  description = "Email address"
  type        = string
}

variable "external_cidr" {
  description = "External cidr"
  type        = string
}

variable "hostname" {
  description = "Hostname for rancher"
  type        = string
}

variable "bootstrapPassword" {
  description = "Bootstrap password"
  type        = string
  sensitive   = true
}

variable "grafana_url" {
  description = "Grafana url"
  type        = string
}

variable "grafana_password" {
  description = "Grafana password"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "Github token"
  type        = string
  sensitive   = true
}
