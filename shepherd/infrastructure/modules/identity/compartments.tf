# defining the compartment
resource "oci_identity_compartment" "deployment_api_service_beta" {
  #Required
  compartment_id = var.tenancy_ocid
  description = "Compartment for API service"
  name = var.deployment_api_compartment_name
}

# defining the compartment
resource "oci_identity_compartment" "deployment_worker_service_beta" {
  #Required
  compartment_id = var.tenancy_ocid
  description = "Compartment for Worker service"
  name = var.worker_compartment_name
}

resource "oci_identity_compartment" "deployment_bastion_beta" {
  #Required
  compartment_id = var.tenancy_ocid
  description = "Bastion compartment"
  name = var.bastion_compartment_name
}

resource "oci_identity_compartment" "deployment_limits_beta" {
  #Required
  compartment_id = var.tenancy_ocid
  description = "Limits compartment"
  name = var.limits_compartment_name
}

resource "oci_identity_compartment" "deployment_splat_beta" {
  compartment_id = var.tenancy_ocid
  description = "Splat compartment"
  name = var.splat_compartment_name
}

# exporting compartment id created
output "deployment_api_service_beta" {
  value          = oci_identity_compartment.deployment_api_service_beta
}

output "deployment_worker_service_beta" {
  value          = oci_identity_compartment.deployment_worker_service_beta
}

output "deployment_bastion_beta" {
  value          = oci_identity_compartment.deployment_bastion_beta
}

output "deployment_limits_beta" {
  value          = oci_identity_compartment.deployment_limits_beta
}