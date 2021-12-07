#Variables


variable "framework_name" {
  description = "Framework name"
}

variable "shipa_token" {
  description = "Shipa Auth Token"
}

variable "cluster_name" {
  description = "Cluster name"
}

##Cluster Specifics can be wired in a few different ways.

variable "kubernetes_endpoint" {
  description = "Kubernetes API Endpoint"
  default     = "https://endpoint.io:6443"
}

variable "role_token" {
  description = "Shipa Role Token"
  default     = "abc123"
}

variable "token_ca_cert" {
  description = "Shipa Role Token CA Cert"
  default     = " -----BEGIN CERTIFICATE-----abc123-----END CERTIFICATE-----"
}

##Shipa App Deploy

variable "app_name" {
  description = "Application name"
}

variable "app_image" {
  description = "Application deployment image"
}
