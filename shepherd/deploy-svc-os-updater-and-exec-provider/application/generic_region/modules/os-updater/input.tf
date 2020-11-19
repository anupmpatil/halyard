variable "availability_domains" {
  type        = list(string)
  description = "List of availability domains to deploy to."
}

variable "artifact_versions" {
  description = "Simple mapping from the injected shepherd artifact versions."
}

variable "artifact_name" {
  description = " artifact name"
}

variable "odo_app_alias_mp" {
  description = "App alias name for Management plane"
}

variable "odo_app_alias_cp" {
  description = "App alias name for Control plane"
}

variable "odo_app_alias_bastion" {
  description = "App alias name for Bastion"
}