variable "execution_target" {}

module "tenancies_config" {
  source = "../common_files"
}

locals {
  deployment_service_control_plane_api_compartment_name    = "deployment_service_control_plane_api"
  deployment_service_management_plane_api_compartment_name = "deployment_service_management_plane_api"
  deployment_service_control_plane_worker_compartment_name = "deployment_service_control_plane_worker"
  deployment_service_data_plane_worker_compartment_name    = "deployment_service_data_plane_worker"
  bastion_compartment_name                                 = "deployment_bastion"
  limits_compartment_name                                  = "deployment_limits"
  splat_compartment_name                                   = "deployment_splat"
  canary_tenancy_ocid                                      = lookup(module.tenancies_config.canary_tenancy_ocid_map, var.execution_target.phase_name, "beta")
  canary_compartment_name                                  = "canary_tests"
}

data "oci_identity_compartments" "all_compartments" {
  compartment_id = var.execution_target.tenancy_ocid
}

data "oci_identity_compartments" "all_canary_compartments" {
  compartment_id = local.canary_tenancy_ocid
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

output "canary_compartment" {
  value = [for c in data.oci_identity_compartments.all_canary_compartments.compartments : c if c.name == local.canary_compartment_name][0]
}

