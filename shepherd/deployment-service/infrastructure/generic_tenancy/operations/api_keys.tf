resource "oci_identity_api_key" "canary_test_user-api-key" {
  key_value = file(format("%s/%s", path.module, var.api_public_key_path))
  user_id   = oci_identity_user.canary_test_user.id
}

resource "oci_identity_api_key" "test_user_1-api-key" {
  key_value = file(format("%s/%s", path.module, var.api_public_key_path))
  user_id   = oci_identity_user.integ_test_user_1.id
}

resource "oci_identity_api_key" "test_user_2-api-key" {
  key_value = file(format("%s/%s", path.module, var.api_public_key_path))
  user_id   = oci_identity_user.integ_test_user_2.id
}

resource "oci_identity_api_key" "test_user_3-api-key" {
  key_value = file(format("%s/%s", path.module, var.api_public_key_path))
  user_id   = oci_identity_user.integ_test_user_3.id
}