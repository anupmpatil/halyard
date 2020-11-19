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
