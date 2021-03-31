resource "oci_functions_application" "test_application" {
  compartment_id = var.compartment_id
  display_name = var.application_display_name
  subnet_ids = var.application_subnet_ids
}

resource "oci_functions_function" "test_function" {
  application_id = oci_functions_application.test_application.id
  display_name = var.function_display_name
  image = var.function_image
  memory_in_mbs = var.function_memory_in_mbs
}