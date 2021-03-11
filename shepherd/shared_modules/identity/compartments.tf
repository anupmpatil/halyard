variable "tenancy_ocid" {
  description = "OCID of tenancy for which to get all compartment information"
}

variable "canary_tenancy_ocid" {
  description = "OCID of canary tenancy for which to get related compartment information"
}

variable "integration_test_tenancy_ocid" {
  description = "OCID of integration test tenancy for which to get related compartment information"
}

locals {
  deployment_service_control_plane_api_compartment_name    = "deployment_service_control_plane_api"
  deployment_service_management_plane_api_compartment_name = "deployment_service_management_plane_api"
  deployment_service_control_plane_worker_compartment_name = "deployment_service_control_plane_worker"
  deployment_service_data_plane_worker_compartment_name    = "deployment_service_data_plane_worker"
  bastion_compartment_name                                 = "deployment_bastion"
  limits_compartment_name                                  = "deployment_limits"
  splat_compartment_name                                   = "deployment_splat"
  canary_test_compartment_name                             = "canary_tests"
  integration_test_compartment_name                        = "integration_tests"
}

data "oci_identity_compartments" "all_compartments" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_compartments" "all_canary_compartments" {
  count          = var.canary_tenancy_ocid == "" ? 0 : 1
  compartment_id = var.canary_tenancy_ocid
}

data "oci_identity_compartments" "all_integration_test_compartments" {
  count          = var.integration_test_tenancy_ocid == "" ? 0 : 1
  compartment_id = var.integration_test_tenancy_ocid
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

output "canary_test_compartment" {
  value = var.canary_tenancy_ocid == "" ? null : [for c in data.oci_identity_compartments.all_canary_compartments.0.compartments : c if c.name == local.canary_test_compartment_name][0]
}

output "integration_test_compartment" {
  value = var.integration_test_tenancy_ocid == "" ? null : [for c in data.oci_identity_compartments.all_integration_test_compartments.0.compartments : c if c.name == local.integration_test_compartment_name][0]
}