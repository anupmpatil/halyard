variable "tenancy_ocid" {
  type        = string
  description = "Tenancy ID."
}

variable "control_plane_compartment_id" {
  type        = string
  description = "Compartment ID where the secret belongs to."
}

variable "management_plane_compartment_id" {
  type        = string
  description = "Compartment ID where the secret belongs to."
}

variable "phonebook_name" {
  type        = string
  description = "Phonebook name for the service."
}

variable "tls_certificate_control_plane_api" {}

variable "tls_certificate_management_plane_api" {}