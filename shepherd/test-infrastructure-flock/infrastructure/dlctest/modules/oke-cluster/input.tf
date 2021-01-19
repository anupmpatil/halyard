variable "compartment_id" {
  type        = string
  description = "Compartment ID where the OB3 jump VCN belongs to."
}

variable "k8s_cluster_version" {
  type        = string
  description = "Compartment ID where the OB3 jump VCN belongs to."
}

variable "vcn_id" {
  type        = string
  description = "vcn where OKE cluster will be created."
}

variable "availability_domains" {
  type        = list(string)
  description = "List of ADs where instances will be deployed."
}

variable "k8s_worker_subnet_id" {
  type        = string
  description = "OCID of subnet where k8s worker will be placed."
}

variable "node_image_id" {
  type        = string
  description = "The image id for service instnaces. The image must be a OCI overlay Image: https://confluence.oci.oraclecorp.com/display/IODOCS/OCI+Overlay+Image+Versions"
}

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy ID."
}
