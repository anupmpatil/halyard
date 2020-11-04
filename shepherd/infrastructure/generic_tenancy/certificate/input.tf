variable "tenancy_ocid" {
  type        = string
  description = "Tenancy ID."
}

variable "environment" {
  type        = string
  description = "Environment in which the infrastructure is setup"
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
