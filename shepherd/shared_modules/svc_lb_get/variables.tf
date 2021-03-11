variable "compartment_id" {
  description = "Compartment's OCID where LBs are located."
}

variable "lb_display_name_regex" {
  description = "Regular expression for finding load balancer by name"
}