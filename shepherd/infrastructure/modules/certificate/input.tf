variable "tenancy_ocid" {
  type = string
  description = "Tenancy ID."
}

variable "compartment_id" {
  type = string
  description = "Compartment ID where the secret belongs to."
}

variable "phonebook_name" {
  type = string
  description = "Phonebook name for the service."
}

variable "tls_certificate" {}