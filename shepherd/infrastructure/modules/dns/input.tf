variable "environment" {
  type        = string
  description = "Environment in which the infrastructure is setup"
}

variable "region" {
  type        = string
  description = "Name of the region"
}

variable "control_plane_api_public_loadbalancer_ip_address" {
  type        = string
  description = "IP address of the loadbalancer"
}
