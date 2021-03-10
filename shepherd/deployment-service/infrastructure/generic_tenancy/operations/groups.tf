resource "oci_identity_group" "integ-test-user-2-group" {
  compartment_id = var.integ_test_tenancy_ocid
  description    = "group for authorization test"
  name           = "integ_test_user_2_group"
}

resource "oci_identity_group" "integ-test-user-3-group" {
  compartment_id = var.integ_test_tenancy_ocid
  description    = "group for authorization test"
  name           = "integ_test_user_3_group"
}