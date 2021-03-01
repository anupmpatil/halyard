resource "oci_identity_user" "canary_test_user" {
  compartment_id = var.canary_tenancy_ocid
  description    = "User used by canary test"
  name           = "canary_test_user"
}