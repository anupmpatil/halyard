resource "oci_logging_log_group" "integration_test_log_group" {
  compartment_id = var.integration_test_compartment_id
  display_name   = "${var.log_group_display_name}_int_test"
}

resource "oci_logging_log_group" "canary_test_log_group" {
  compartment_id = var.canary_test_compartment_id
  display_name   = "${var.log_group_display_name}_canary_test"
}