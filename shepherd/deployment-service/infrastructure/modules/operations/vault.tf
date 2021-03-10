resource "oci_kms_vault" "canary_vault" {
  compartment_id = var.canary_test_compartment_id
  display_name   = "CanaryVault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "test_key" {
  compartment_id = var.canary_test_compartment_id
  display_name   = "CanaryTestKey"
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  management_endpoint = oci_kms_vault.canary_vault.management_endpoint
}

resource "oci_kms_vault" "integ_test_vault" {
  compartment_id = var.integration_test_compartment_id
  display_name   = "IntegrationTestVault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "integ_test_key" {
  compartment_id = var.integration_test_compartment_id
  display_name   = "IntegrationTestKey"
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  management_endpoint = oci_kms_vault.integ_test_vault.management_endpoint
}