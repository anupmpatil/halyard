variable "canaries_list" {
  type        = list(string)
  description = "List containing all the canary names."
}

variable "canaries_compartment_id" {
  type        = string
  description = "Compartment ID for deployment service canaries."
}

variable "environment" {
  type        = string
  description = "Environment of the canary execution. (beta/preprod/prod)."
}

variable "t2_project_name" {
  type        = string
  description = "T2 project name."
}

variable "canary_frequency_map" {
  type        = map(any)
  description = "Frequency map for the canaries running time."
}

variable "canary_maxruntime_map" {
  type        = map(any)
  description = "Maximum runtime map for the canaries."
}

variable "canaries_test_method_map" {
  type        = map(any)
  description = "Mapping of canaries name to the TEST_METHOD."
}

variable "artifact_versions" {
  description = "Simple mapping from the injected shepherd artifact versions."
}

variable "availability_domains" {
  type        = list(string)
  description = "List of availability domains to deploy to."
}

variable "execution_target" {
  type        = string
  description = "The current execution target"
}