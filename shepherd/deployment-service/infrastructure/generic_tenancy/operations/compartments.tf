resource "oci_identity_compartment" "e2e_integration_tests_compartment" {
  compartment_id = var.canary_test_tenancy_ocid
  name           = "canary_tests"
  description    = "Compartment used by canary tests"
}

resource "oci_identity_compartment" "integration_test_compartment" {
  compartment_id = var.integ_test_tenancy_ocid
  name           = "integration_tests"
  description    = "Compartment used by integration tests"
}
