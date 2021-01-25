locals {
  kiev_name_map = {
    beta    = "beta"
    preprod = "preprod"
    prod    = "production"
  }
}

resource "kaas_regional_instance" "kaas_instance" {
  compartment_id   = var.compartment_id
  kiev_name        = "${var.service_name}-${lookup(local.kiev_name_map, var.environment, "beta")}"
  location         = "OVERLAY" # SUBSTRATE or OVERLAY
  phone_book_entry = var.phone_book_name
}
