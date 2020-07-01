variable "compartment_id" {
  type        = string
  description = "Compartment ID for your ODO application."
}

variable "availability_domains" {
  type        = list(string)
  description = "List of availability domains to deploy to."
}

variable "log_namespace" {
  type        = string
  description = "Lumberjack's registered namespace."
}

variable "environment" {
  type        = string
  description = "Environment of the log space. (beta/prod)"
}
