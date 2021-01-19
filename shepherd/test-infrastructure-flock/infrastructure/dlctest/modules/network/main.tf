locals {
  tcp_protocol  = "6"
  udp_protocol  = "17"
  icmp_protocol = "1"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
}

//The VCN where test infrastructure will reside.
resource "oci_core_vcn" "ig_test_vcn" {
  cidr_block     = var.service_vcn_cidr
  compartment_id = var.compartment_id
  display_name   = "vcn_${var.service_name}"
  dns_label      = var.dns_label
}

// An Internet gateway.
resource "oci_core_internet_gateway" "ig_test_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.ig_test_vcn.id
  display_name   = "ig_test_internet_gateway"
}

// Route outbound traffic to internet gateway.
resource "oci_core_route_table" "subnet_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.ig_test_vcn.id
  display_name   = "route_table_${oci_core_vcn.ig_test_vcn.display_name}"
  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig_test_internet_gateway.id
  }
}

// Subnet where we will place all resources needed in test infrastructure.
resource "oci_core_subnet" "ig_test_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.ig_test_vcn.id
  cidr_block     = cidrsubnet(var.service_vcn_cidr, 1, 0)
  route_table_id = oci_core_route_table.subnet_route_table.id
  display_name   = "subnet_lb_${oci_core_vcn.ig_test_vcn.display_name}"
  dns_label      = var.region.name
}