resource "oci_identity_policy" "test-service-to-access-secret" {
  compartment_id = var.canary_test_tenancy_ocid
  description    = "Allow test service hosts to download secret with resource principal in tenancy"
  name           = "test-service-to-access-secret-${var.environment}"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.exec-service-resource-principal-support.name} to read secret-family in compartment ${oci_identity_compartment.e2e_integration_tests_compartment.name}"
  ]
}

resource "oci_identity_policy" "test-service-to-access-secret-integ-test" {
  compartment_id = var.integ_test_tenancy_ocid
  description    = "Allow test service hosts to download secret with resource principal in tenancy"
  name           = "test-service-to-access-secret-integ-test-${var.environment}"
  statements = [
    "allow dynamic-group ${oci_identity_dynamic_group.exec-service-resource-principal-support-integ-test.name} to read secret-family in compartment ${oci_identity_compartment.integration_test_compartment.name}"
  ]
}

resource "oci_identity_policy" "authorization-test-policy" {
  compartment_id = var.integ_test_tenancy_ocid
  description    = "Policies to test authorization"
  name           = "authorization-test-policy-${var.environment}"
  statements = [
    "Allow group ${oci_identity_group.integ-test-user-2-group.name} to manage devops-project in in compartment ${oci_identity_compartment.integration_test_compartment.name}",
    "Allow group ${oci_identity_group.integ-test-user-3-group.name} to inspect devops-project in compartment ${oci_identity_compartment.integration_test_compartment.name}"
  ]
}
