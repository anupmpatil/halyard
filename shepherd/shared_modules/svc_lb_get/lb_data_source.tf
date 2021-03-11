data "oci_load_balancer_load_balancers" "public" {
  compartment_id = var.compartment_id
  detail         = "full"
  filter {
    name   = "display_name"
    values = [var.lb_display_name_regex]
    regex  = true
  }
}