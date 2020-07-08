variable "deployment_api_compartment_id" {
  type        = string
  description = "API Compartment ID for deployment service ODO application."
}

variable "deployment_worker_compartment_id" {
  type        = string
  description = "Worker Compartment ID for deployment service ODO application."
}

variable "availability_domains" {
  type        = list(string)
  description = "List of availability domains to deploy to."
}

variable "name_prefix" {
  type        = string
  description = "Prefix for names(ODO and odo pool)."
}

variable "release_name" {
  type        = string
  description = "Name of the shepherd release."
}

variable "stage" {
  type        = string
  description = "Stage of the application."
}

variable "odo_application_type" {
  description = "Specifies the ODO application's type: https://confluence.oci.oraclecorp.com/display/odo/Application+Types."
}

variable "api_instance_pools" {
  description = "Instance pools for api."
}

variable "worker_instance_pools" {
  description = "Instance pools for worker."
}

variable "api_artifact_name" {
  description = "API artifact name"
}

variable "worker_artifact_name" {
  description = "Worker artifact name"
}
