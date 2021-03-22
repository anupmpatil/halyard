variable "worker_compartment_id" {
  type        = string
  description = "Compartment ID for your worker lumberjack logs"
}

variable "availability_domains" {
  type        = list(string)
  description = "List of availability domains to deploy to."
}

variable "log_namespace_worker" {
  type        = string
  description = "Lumberjack's worker registered namespace."
}

variable "environment" {
  type        = string
  description = "Environment of the log space. (beta/prod)"
}
