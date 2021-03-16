variable "odo_api_application" {
  description = "API ODO App"
}

variable "odo_worker_application" {
  description = "worker service ODO App"
}

variable "availability_domains" {
  type        = list(string)
  description = "List of availability domains to deploy to."
}

variable "artifact_versions" {
  description = "Simple mapping from the injected shepherd artifact versions."
}

variable "api_artifact_name" {
  description = "API artifact name"
}

variable "worker_artifact_name" {
  description = "Worker artifact name"
}

variable "execution_target" {
  type        = string
  description = "The current execution target"
}

variable "integration_test_compartment_id" {
  description = "The compartment id map for post deployment test"
}

variable "environment" {
  description = "The current execution environment"
}