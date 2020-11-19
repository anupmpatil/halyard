resource "oci_identity_compartment" "deployment_service_control_plane_api" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for control plane api service"
  name           = var.deployment_service_control_plane_api_compartment_name
}

resource "oci_identity_compartment" "deployment_service_management_plane_api" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for management plane api service"
  name           = var.deployment_service_management_plane_api_compartment_name
}

resource "oci_identity_compartment" "deployment_service_control_plane_worker" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for control plane worker"
  name           = var.deployment_service_control_plane_worker_compartment_name
}

resource "oci_identity_compartment" "deployment_service_data_plane_worker" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for data plane worker"
  name           = var.deployment_service_data_plane_worker_compartment_name
}

resource "oci_identity_compartment" "deployment_bastion" {
  compartment_id = var.tenancy_ocid
  description    = "Bastion compartment"
  name           = var.bastion_compartment_name
}

resource "oci_identity_compartment" "deployment_limits" {
  compartment_id = var.tenancy_ocid
  description    = "Limits compartment"
  name           = var.limits_compartment_name
}

resource "oci_identity_compartment" "deployment_splat" {
  compartment_id = var.tenancy_ocid
  description    = "Splat compartment"
  name           = var.splat_compartment_name
}

# exporting compartment id created
output "deployment_service_control_plane_api" {
  value = oci_identity_compartment.deployment_service_control_plane_api
}

output "deployment_service_management_plane_api" {
  value = oci_identity_compartment.deployment_service_management_plane_api
}

output "deployment_service_control_plane_worker" {
  value = oci_identity_compartment.deployment_service_control_plane_worker
}

output "deployment_service_data_plane_worker" {
  value = oci_identity_compartment.deployment_service_data_plane_worker
}

output "deployment_bastion" {
  value = oci_identity_compartment.deployment_bastion
}

output "deployment_limits" {
  value = oci_identity_compartment.deployment_limits
}