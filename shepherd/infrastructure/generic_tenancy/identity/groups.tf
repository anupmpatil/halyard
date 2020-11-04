resource "oci_identity_dynamic_group" "odo_dynamic_group" {
  lifecycle {
    prevent_destroy = true
  }
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for ODO policies"
  matching_rule  = "ANY {instance.compartment.id = '${oci_identity_compartment.deployment_service_control_plane_api.id}', instance.compartment.id = '${oci_identity_compartment.deployment_service_control_plane_worker.id}', instance.compartment.id = '${oci_identity_compartment.deployment_service_management_plane_api.id}', instance.compartment.id = '${oci_identity_compartment.deployment_service_data_plane_worker.id}' }"
  name           = "odo-dynamic-group"
}

resource "oci_identity_dynamic_group" "access_managers_dynamic_group" {
  lifecycle {
    prevent_destroy = true
  }
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for service instance whitelisting"
  matching_rule  = "ANY {instance.compartment.id = '${oci_identity_compartment.deployment_service_control_plane_worker.id}', instance.compartment.id = '${oci_identity_compartment.deployment_service_control_plane_api.id}', instance.compartment.id = '${oci_identity_compartment.deployment_bastion.id}', instance.compartment.id = '${oci_identity_compartment.deployment_service_management_plane_api.id}', instance.compartment.id = '${oci_identity_compartment.deployment_service_data_plane_worker.id}' }"
  name           = "access-managers"
}

resource "oci_identity_dynamic_group" "deployment_worker_service_dynamic_group" {
  lifecycle {
    prevent_destroy = true
  }
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for workflow service"
  matching_rule  = "ANY {instance.compartment.id = '${oci_identity_compartment.deployment_service_control_plane_worker.id}', instance.compartment.id = '${oci_identity_compartment.deployment_service_data_plane_worker.id}' }"
  name           = "deployment_worker_service_dynamic_group"
}

output "odo_dynamic_group" {
  value = oci_identity_dynamic_group.odo_dynamic_group
}

output "access_managers_dynamic_group" {
  value = oci_identity_dynamic_group.access_managers_dynamic_group
}

output "deployment_worker_service_dynamic_group" {
  value = oci_identity_dynamic_group.deployment_worker_service_dynamic_group
}