resource "oci_identity_api_key" "canary_test_user-api-key" {
  key_value = file(format("%s/%s", path.module, var.api_public_key_path))
  user_id   = oci_identity_user.canary_test_user.id
}