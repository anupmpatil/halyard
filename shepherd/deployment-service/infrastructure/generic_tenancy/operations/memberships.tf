data "oci_identity_groups" "canary_administrators_groups" {
  compartment_id = var.canary_test_tenancy_ocid
  filter {
    name   = "name"
    values = ["Administrators"]
  }
}

data "oci_identity_groups" "integ_test_administrators_groups" {
  compartment_id = var.integ_test_tenancy_ocid
  filter {
    name   = "name"
    values = ["Administrators"]
  }
}

resource "oci_identity_user_group_membership" "canary_administrators_groups-canary_test_user" {
  group_id = data.oci_identity_groups.canary_administrators_groups.groups[0].id
  user_id  = oci_identity_user.canary_test_user.id
}

resource "oci_identity_user_group_membership" "integ_test_administrators_groups-integ_test_user_1" {
  group_id = data.oci_identity_groups.integ_test_administrators_groups.groups[0].id
  user_id  = oci_identity_user.integ_test_user_1.id
}

resource "oci_identity_user_group_membership" "integ_test_user_2_group-integ_test_user_2" {
  group_id = oci_identity_group.integ-test-user-2-group.id
  user_id  = oci_identity_user.integ_test_user_2.id
}

resource "oci_identity_user_group_membership" "integ_test_user_3_group-integ_test_user_3" {
  group_id = oci_identity_group.integ-test-user-3-group.id
  user_id  = oci_identity_user.integ_test_user_3.id
}