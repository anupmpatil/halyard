########### rqs variables ###########

variable "control_plane_compartment_id" {
  description = "OCID of the compartment in service tenancy owning RQS schema."
}

variable "management_plane_compartment_id" {
  description = "OCID of the compartment in service tenancy owning RQS schema."
}

variable "environment" {
  description = "Environment"
}

variable "scope" {
  default = "CUSTOMER"
}

variable "phone_book_id" {}