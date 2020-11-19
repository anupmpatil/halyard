variable "service_name" {
  type        = string
  description = "Service name, mostly used for naming purposes."
}

variable "compartment_id" {
  type        = string
  description = "Compartment ID for the kiev instance related resources."
}

variable "environment" {
  type        = string
  description = "Environment of the log space. (beta/prod)"
}
