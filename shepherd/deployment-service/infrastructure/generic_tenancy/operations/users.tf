resource "oci_identity_user" "canary_test_user" {
  compartment_id = var.canary_test_tenancy_ocid
  description    = "User used by canary test"
  name           = "canary_test_user"
}

resource "oci_identity_user" "integ_test_user_1" {
  compartment_id = var.integ_test_tenancy_ocid
  description    = "User used by integration test"
  name           = "integ_test_user_1"
}

resource "oci_identity_user" "integ_test_user_2" {
  compartment_id = var.integ_test_tenancy_ocid
  description    = "User used by integration test"
  name           = "integ_test_user_2"
}

resource "oci_identity_user" "integ_test_user_3" {
  compartment_id = var.integ_test_tenancy_ocid
  description    = "User used by integration test"
  name           = "integ_test_user_3"
}