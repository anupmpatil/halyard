resource "kaas_regional_instance" "kaas_instance" {
  compartment_id = var.compartment_id
  kiev_name      = "${var.service_name}-${var.stage}"
  location       = "OVERLAY" # SUBSTRATE or OVERLAY
}
