variable "execution_target" {}

locals {
  deployment_service_control_plane_api_compartment_name    = "deployment_service_control_plane_api"
  deployment_service_management_plane_api_compartment_name = "deployment_service_management_plane_api"
  deployment_service_control_plane_worker_compartment_name = "deployment_service_control_plane_worker"
  deployment_service_data_plane_worker_compartment_name    = "deployment_service_data_plane_worker"
  bastion_compartment_name                                 = "deployment_bastion"
  limits_compartment_name                                  = "deployment_limits"
  splat_compartment_name                                   = "deployment_splat"
}

data "oci_identity_compartments" "all_compartments" {
  compartment_id = var.execution_target.tenancy_ocid
}

//Fetching identity resources(compartments) created in another execution target by means of their names
output "deployment_service_control_plane_api_compartment" {
  value = [for c in data.oci_identity_compartments.all_compartments.compartments : c if c.name == local.deployment_service_control_plane_api_compartment_name][0]
}

output "deployment_service_management_plane_api_compartment" {
  value = [for c in data.oci_identity_compartments.all_compartments.compartments : c if c.name == local.deployment_service_management_plane_api_compartment_name][0]
}

output "deployment_service_control_plane_worker_compartment" {
  value = [for c in data.oci_identity_compartments.all_compartments.compartments : c if c.name == local.deployment_service_control_plane_worker_compartment_name][0]
}

output "deployment_service_data_plane_worker_compartment" {
  value = [for c in data.oci_identity_compartments.all_compartments.compartments : c if c.name == local.deployment_service_data_plane_worker_compartment_name][0]
}

output "bastion_compartment" {
  value = [for c in data.oci_identity_compartments.all_compartments.compartments : c if c.name == local.bastion_compartment_name][0]
}

output "limits_compartment" {
  value = [for c in data.oci_identity_compartments.all_compartments.compartments : c if c.name == local.limits_compartment_name][0]
}

output "splat_compartment" {
  value = [for c in data.oci_identity_compartments.all_compartments.compartments : c if c.name == local.splat_compartment_name][0]
}