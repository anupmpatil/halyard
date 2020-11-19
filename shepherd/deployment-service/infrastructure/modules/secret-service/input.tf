variable "control_plane_api_compartment_id" {
  type        = string
  description = "Compartment ID where the secret belongs to."
}

variable "management_plane_api_compartment_id" {
  type        = string
  description = "Compartment ID where the secret belongs to."
}

variable "control_plane_api_namespace" {
  type        = string
  default     = "deployment-service-control-plane-api"
  description = "Name of the namespace for the secrets."
}

variable "management_plane_api_namespace" {
  type        = string
  default     = "deployment-service-management-plane-api"
  description = "Name of the namespace for the secrets."
}

variable "team_queue" {
  type        = string
  description = "Team queue name of the service owner."
}
