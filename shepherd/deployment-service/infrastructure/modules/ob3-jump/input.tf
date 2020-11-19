variable "bastion_compartment_id" {
  type        = string
  description = "Compartment ID where the OB3 jump VCN belongs to."
}

variable "ob3_bastion_cidr" {
  type        = string
  description = "The CIDR of the OverlayBastion3(OB3) VCN. Should be provided by SecEdge team."
}

variable "jump_vcn_cidr" {
  type        = string
  description = "The CIDR block for the jump VCN. Should be assigned by the SecEdge team."
}

variable "jump_instance_shape" {
  type        = string
  default     = "VM.Standard2.1"
  description = "The shape of the jump instance."
}

variable "jump_instance_image_id" {
  type        = string
  description = "The image id for the jump instance. Note: it must be chef enabled."
}

variable "jump_instance_ad" {
  type        = string
  description = "The availability zone where you want to run the jump instance."
}

variable "jump_instance_hostclass" {
  type        = string
  description = "The overlay hostclass that your jump instance belongs to."
}

variable "service_vcn_cidr" {
  type        = string
  description = "The CIDR block for your service VCN."
}

variable "management_plane_service_vcn_cidr" {
  type        = string
  description = "The CIDR block for management plane service VCN."
}

variable "service_vcn_lpg_id" {
  type        = string
  description = "The service VCN's LPG ID that jump VCN should pair to."
}

variable "management_plane_vcn_lpg_id" {
  type        = string
  description = "The management plane VCN's LPG ID that jump VCN should pair to."
}

variable "jump_instance_display_name" {
  type    = string
  default = "ob3_jump_instance."
}

variable "region" {
  type        = string
  description = "The region for this service."
}

variable "tenancy_ocid" {
  type        = string
  description = "REQUIRED: Tenancy OCID"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for names(ODO and odo pool)."
}

variable "release_name" {
  type        = string
  description = "Name of the shepherd release."
}

variable "stage" {
  type        = string
  description = "Stage of the application."
}

variable "odo_application_type" {
  description = "Specifies the ODO application's type: https://confluence.oci.oraclecorp.com/display/odo/Application+Types."
}

variable "availability_domain" {
  type        = string
  description = "availability domain to deploy to."
}