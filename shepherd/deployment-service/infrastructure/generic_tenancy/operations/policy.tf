resource "oci_identity_policy" "test-service-to-access-secret" {
  compartment_id = var.canary_tenancy_ocid
  description    = "Allow test service hosts to download secret with resource principal in tenancy"
  name           = "test-service-to-access-secret-${var.environment}"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.exec-service-resource-principal-support.name} to read secret-family in compartment ${oci_identity_compartment.e2e_integration_tests_compartment.name}"
  ]
}
