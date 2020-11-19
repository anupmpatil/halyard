variable "availability_domains" {
  type        = list(string)
  description = "List of availability domains to deploy to."
}

variable "compartment_id" {
  type        = string
  description = "The compartment ocid the service is running in."
}

variable "artifact_versions" {
  description = "Simple mapping from the injected shepherd artifact versions."
}

variable "artifact_name" {
  description = " artifact name"
}

variable "maximum_run_time_ms" {
  type        = number
  description = "Maximum allowed time in milliseconds for integration tests to complete execution."
  default     = 3600000
}

variable "maximum_number_of_attempts" {
  type        = number
  description = "Maximum nummber of attempts."
  default     = 1
}

variable "maximum_postprocess_time_ms" {
  type        = number
  description = "Maximum allowed time in milliseconds for integration tests to complete postprocessing."
  default     = 300000
}

variable "maximum_preprocess_time_ms" {
  type        = number
  description = "Maximum allowed time in milliseconds for integration tests to complete preprocessing."
  default     = 300000
}