# This policy is for test service resource principal used canary test.
resource "oci_identity_dynamic_group" "exec-service-resource-principal-support" {
  compartment_id = var.canary_test_tenancy_ocid
  name           = "exec-service-resource-principal-support-${var.environment}"
  description    = "Dynamic group for exec service to support resource principal"
  matching_rule  = "resource.type='execservicetest'"
}

# This policy is for test service resource principal used integration test.
resource "oci_identity_dynamic_group" "exec-service-resource-principal-support-integ-test" {
  compartment_id = var.integ_test_tenancy_ocid
  name           = "exec-service-resource-principal-support-integ-test-${var.environment}"
  description    = "Dynamic group for exec service to support resource principal"
  matching_rule  = "resource.type='execservicetest'"
}