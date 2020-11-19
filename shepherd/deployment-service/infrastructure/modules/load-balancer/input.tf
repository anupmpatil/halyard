/*
  Root input arguments for this terraform module.
*/
variable "compartment_id" {
  type        = string
  description = "Compartment ID of the load balancer resources."
}

variable "lb_shape" {
  type        = string
  description = "Shape of the load balancer."
  default     = "100Mbps"
}

variable "display_name" {
  type        = string
  description = "Load balancer's display name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet where this LB is attached to. Assuming it would be a regional subnet."
}

variable "listener_port" {
  type        = string
  description = "The listener's port."
}

variable "host_listening_port" {
  type        = string
  description = "Hosts' listening port."
}
