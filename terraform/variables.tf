variable "config_path" {
  description = "Kube config file"
  type        = string
}

variable "external_cidr" {
  description = "External cidr"
  type        = string
}

variable "github_token" {
  description = "Github token"
  type        = string
  sensitive   = true
}

variable "registry_password" {
  description = "Github registry password"
  type        = string
  sensitive   = true
}

variable "clientId" {
  description = "Tailscale client id"
  type        = string
  sensitive   = true
}

variable "clientSecret" {
  description = "Tailscale client secret"
  type        = string
  sensitive   = true
}

variable "vault_token" {
  description = "Vault token"
  type        = string
  sensitive   = true
}
