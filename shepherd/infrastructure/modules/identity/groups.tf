resource "oci_identity_dynamic_group" "odo_dynamic_group" {
  lifecycle {
    prevent_destroy = true
  }
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for ODO policies"
  matching_rule  = "ANY {instance.compartment.id = '${oci_identity_compartment.deployment_api_service_beta.id}', instance.compartment.id = '${oci_identity_compartment.deployment_worker_service_beta.id}' }"
  name           = "odo-dynamic-group"
}

resource "oci_identity_dynamic_group" "access_managers_dynamic_group" {
  lifecycle {
    prevent_destroy = true
  }
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for service instance whitelisting"
  matching_rule  = "ANY { instance.compartment.id = '${oci_identity_compartment.deployment_worker_service_beta.id}', instance.compartment.id = '${oci_identity_compartment.deployment_api_service_beta.id}', instance.compartment.id = '${oci_identity_compartment.deployment_bastion_beta.id}' }"
  name           = "access-managers"
}

output "odo_dynamic_group" {
  value = oci_identity_dynamic_group.odo_dynamic_group
}

output "access_managers_dynamic_group" {
  value = oci_identity_dynamic_group.access_managers_dynamic_group
}
