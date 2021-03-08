# This policy is for test service resource principal used integration test.
resource "oci_identity_dynamic_group" "exec-service-resource-principal-support" {
  compartment_id = var.canary_tenancy_ocid
  name           = "exec-service-resource-principal-support-${var.environment}"
  description    = "Dynamic group for exec service to support resource principal"
  matching_rule  = "resource.type='execservicetest'"
}