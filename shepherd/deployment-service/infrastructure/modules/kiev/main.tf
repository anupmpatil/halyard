resource "kaas_regional_instance" "kaas_instance" {
  compartment_id   = var.compartment_id
  kiev_name        = "${var.service_name}-${var.environment}"
  location         = "OVERLAY" # SUBSTRATE or OVERLAY
  phone_book_entry = var.phone_book_name
}
