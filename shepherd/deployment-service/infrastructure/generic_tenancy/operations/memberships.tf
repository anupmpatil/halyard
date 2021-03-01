data "oci_identity_groups" "canary_administrators_groups" {
  compartment_id = var.canary_tenancy_ocid
  filter {
    name   = "name"
    values = ["Administrators"]
  }
}

resource "oci_identity_user_group_membership" "canary_administrators_groups-canary_test_user" {
  group_id = data.oci_identity_groups.canary_administrators_groups.groups[0].id
  user_id  = oci_identity_user.canary_test_user.id
}