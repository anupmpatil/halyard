variable "compartment_id" {
  type        = string
  description = "Compartment OCID"
}

variable "application_display_name" {
  type        = string
  description = "Function Application display name"
}

variable "application_subnet_ids" {
  type        = string
  description = "OCID of subnet where function will be placed."
}

variable "function_display_name" {
  type        = string
  description = "Function display name"
}

variable "function_image" {}

variable "function_memory_in_mbs" {}