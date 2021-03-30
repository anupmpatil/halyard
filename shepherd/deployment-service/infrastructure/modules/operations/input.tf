variable "canary_test_compartment_id" {
  description = "OCID of the canary_tests compartment in canary tenancy."
}

variable "integration_test_compartment_id" {
  description = "OCID of the integration_tests compartment in integ test tenancy."
}

variable "log_group_display_name" {
  description = "logGroup name in test tenancy."
}