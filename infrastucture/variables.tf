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
}
