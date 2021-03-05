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

variable "name_prefix_worker" {
  type        = string
  description = "Prefix for names(ODO and odo pool) for worker apps."
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

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy ID."
}

variable "management_plane_api_compartment_id" {
  type        = string
  description = "Management plane compartment OCID"
}

variable "control_plane_api_compartment_id" {
  type        = string
  description = "Management plane compartment OCID"
}

variable "cp_worker_compartment_id" {
  type        = string
  description = "Control plane worker compartment OCID"
}

variable "dp_worker_compartment_id" {
  type        = string
  description = "Data plane worker compartment OCID"
}

variable "project_svc_cp_compartment_id" {
  type        = string
  description = "Project service control plane compartment OCID"
}

variable "control_plane_kiev_endpoint" {
  type        = string
  description = "Control-plane kiev endpoint"
}

variable "data_plane_kiev_endpoint" {
  type        = string
  description = "Data-plane kiev endpoint"
}

variable "control_plane_kiev_store_name" {
  type        = string
  description = "Control-plane kiev store name"
}

variable "data_plane_kiev_store_name" {
  type        = string
  description = "Data-plane kiev store name"
}

