resource "oci_identity_compartment" "e2e_integration_tests_compartment" {
  compartment_id = var.canary_tenancy_ocid
  name           = "canary_tests"
  description    = "Compartment used by canary tests"
}
