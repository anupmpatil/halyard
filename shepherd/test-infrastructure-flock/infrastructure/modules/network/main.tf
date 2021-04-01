locals {
  tcp_protocol  = "6"
  udp_protocol  = "17"
  icmp_protocol = "1"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
}

//The VCN where test infrastructure will reside.
resource "oci_core_vcn" "test_vcn" {
  //10.0.0.0/16
  cidr_block     = var.service_vcn_cidr
  compartment_id = var.compartment_id
  display_name   = "test_vcn_${var.service_name}"
  dns_label      = var.dns_label
}

// Create Internet Gateway for public subnet routing table
resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "test_internet_gateway"
}

// Public route table Route outbound traffic to internet gateway.
resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "route_table_${oci_core_vcn.test_vcn.display_name}"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

// Subnet where we will place all resources needed in test infrastructure.
resource "oci_core_subnet" "test_subnet_public" {
  #Required
  availability_domain = data.oci_identity_availability_domain.ad1.name
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.test_vcn.id
  //cidr_block          = "10.0.20.0/24"
  cidr_block     = cidrsubnet(var.service_vcn_cidr, 1, 0)
  route_table_id = oci_core_route_table.public_route_table.id
  display_name   = "subnet_lb_${oci_core_vcn.ig_test_vcn.display_name}"
  dns_label      = var.region.name
}


// Create NAT gateway private subnet routing table
resource "oci_core_nat_gateway" "test_nat_gateway" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.test_vcn.id

    #Optional
    //block_traffic = var.nat_gateway_block_traffic
    display_name = var.nat_gateway_display_name
}



// private subnet for node pool
resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.oke_vcn.id
  display_name   = "tfClustersRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.test_nat_gateway.id
  }
}

// private subnet for nodepool
resource "oci_core_subnet" "test_subnet_private" {
  #Required
  cidr_block     = "10.0.10.0/24"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.oke_vcn.id

  # Provider code tries to maintain compatibility with old versions.
  security_list_ids = [oci_core_vcn.oke_vcn.default_security_list_id]
  display_name      = "regionalSubnet1"
  route_table_id    = oci_core_route_table.private_route_table.id
}

// Create load balancer
resource "oci_load_balancer_load_balancer" "service_public_loadbalancer" {
  compartment_id = var.compartment_id
  display_name   = var.lb_display_name
  shape          = var.lb_shape
  subnet_ids     = [oci_core_subnet.test_subnet_public]
  is_private     = false
}