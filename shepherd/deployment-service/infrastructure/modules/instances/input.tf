variable "region" {
  type        = string
  description = "The region to create instances."
}

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy ID."
}

variable "compartment_id" {
  type        = string
  description = "Compartment ID where the OB3 jump VCN belongs to."
}

variable "service_instance_name_prefix" {
  type        = string
  description = "Instance display name's prefix."
}

variable "service_instance_shape" {
  type        = string
  default     = "VM.Standard.E3.Flex"
  description = "The shape of service instance."
}

variable "instance_shape_config" {
  type        = map(string)
  default     = { ocpus = 1 }
  description = "Instance shape config"
}

variable "service_instance_image_id" {
  type        = string
  description = "The image id for service instnaces. The image must be a OCI overlay Image: https://confluence.oci.oraclecorp.com/display/IODOCS/OCI+Overlay+Image+Versions"
}

variable "service_instances_hostclass_name" {
  type        = string
  description = "The hostclass that your instances belong to."
}

variable "service_instances_oci_fleet" {
  type        = string
  description = "OCI fleet name, used by splunk."
}

variable "service_instance_availability_domains" {
  type        = list(string)
  description = "List of ADs where instances will be deployed."
}

variable "instance_count_per_ad" {
  type        = number
  description = "Number of compute instances per availability domain."
}

variable "service_subnet_id" {
  type        = string
  description = "Subnet to host service's compute instances."
}

variable "attach_to_lb" {
  type        = bool
  description = "Whether or not to attach instances to load balancer."
}

variable "lb_backend_set_name" {
  type        = string
  description = "The backend set name that each instance should be added to."
  default     = ""
}

variable "load_balancer_id" {
  type        = string
  description = "ID of the load balancer that each instance should be added to."
  default     = ""
}

variable "application_port" {
  type        = string
  description = "The port hosts listen on."
  default     = ""
}
