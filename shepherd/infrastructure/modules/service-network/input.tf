// The region where you're provisioning resources.
variable "region" {}

variable "compartment_id" {
  type        = string
  description = "Compartment ID for the service VCN related resources."
}

variable "service_vcn_cidr" {
  type        = string
  description = "The CIDR block of VCN where your application will run. Make sure there would be enough IP space for your service."
  default     = "10.0.0.0/16"
}

variable "jump_vcn_cidr" {
  type        = string
  description = "The CIDR block of the OB3 jump VCN. Should be provided by SecEdge team. Please refer to the ob3-jump section."
}

variable "service_subnet_cidr_offset" {
  type        = number
  description = "The CIDR offset for service subnet."
  default     = 1
}

variable "service_name" {
  type        = string
  description = "Service name, mostly used for naming purposes."
}

variable "dns_label" {
  type        = string
  description = "DNS label for resources within this VCN."
  default     = ""
}

variable "host_listening_port" {
  type        = string
  description = "Hosts' listening port."
}

variable "lb_listener_port" {
  type        = string
  description = "The load balancer listener's port."
}
