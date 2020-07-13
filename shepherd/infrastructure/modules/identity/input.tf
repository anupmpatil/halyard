variable "tenancy_ocid" {
  type        = string
  description = "REQUIRED: Tenancy OCID"
}

variable "deployment_service_control_plane_api_compartment_name" {
  type        = string
  description = "REQUIRED: name for the control plane api compartment"
}

variable "deployment_service_management_plane_api_compartment_name" {
  type        = string
  description = "REQUIRED: name for the management plane api compartment"
}

variable "deployment_service_control_plane_worker_compartment_name" {
  type        = string
  description = "REQUIRED: name for the control plane worker compartment"
}

variable "deployment_service_data_plane_worker_compartment_name" {
  type        = string
  description = "REQUIRED: name for the data plane worker compartment"
}

variable "bastion_compartment_name" {
  type        = string
  description = "REQUIRED: name for the Bastion compartment"
}

variable "limits_compartment_name" {
  type        = string
  description = "REQUIRED: name for the Limits compartment"
}

variable "splat_compartment_name" {
  type        = string
  description = "REQUIRED: name for the Splat compartment"
}

variable "odo_tenancy_ocid" {
  type        = string
  description = "REQUIRED: OCID for ODO Tenancy"
}

variable "secinf_tenancy_ocid" {
  type        = string
  description = "Secinf tenancy OCID for access-manager policy creation"
}

variable "boat_tenancy_ocid" {
  type        = string
  description = "BOAT tenancy OCID"
}

variable "dlcdep_sys_admins_ocid" {
  default     = "ocid1.group.oc1..aaaaaaaalwjkmzfsjecrgypzwvkt5xadsty56wdlq4evoapxinvsazzrn44a"
  description = "OCID of sys_admins group"
}

variable "telemetry_tenancy_ocid" {
  type        = string
  description = "T2 tenant OCID for telemetry_policy"
}

variable "limits_group_ocid" {
  type        = string
  description = "Limits Group OCID for limits_policy"
}

variable "service_principal_name" {
  type        = string
  description = "Service principal name"
}