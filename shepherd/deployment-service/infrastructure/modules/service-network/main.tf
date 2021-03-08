// Retrieve all available regions.
data "oci_identity_regions" "service_regions" {
}

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

locals {
  dns_label     = var.dns_label == "" ? var.service_name : var.dns_label
  tcp_protocol  = "6"
  udp_protocol  = "17"
  icmp_protocol = "1"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
}

//The VCN where your applicaiton will run.
resource "oci_core_vcn" "service_vcn" {
  cidr_block     = var.service_vcn_cidr
  compartment_id = var.compartment_id_api
  display_name   = "vcn_${var.service_name}"
  dns_label      = local.dns_label
}

/*
  The NAT gateway for your service. This is necessary if your service needs to
  communicate with other services outisde your private network.
*/
resource "oci_core_nat_gateway" "service_vcn_nat" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "nat_${oci_core_vcn.service_vcn.display_name}"
}

// Local Peering Gateway (LPG) that connects to your jump vcn.
resource "oci_core_local_peering_gateway" "service_jump_lpg" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "lpg_ob3jump_to_service"
}

resource "oci_core_service_gateway" "service_vcn_service_gateway" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "service_gateway_${oci_core_vcn.service_vcn.display_name}"
  services {
    service_id = lookup(data.oci_core_services.all_oci_services.services[0], "id")
  }
}

/*
 * Route table for the Jump VCN. Should at minimum contain the following entries:
 *   1. 0.0.0.0/0 -> NAT Gateway: This is to ensure the jump instance can talk
      to services that lies outside the VCN like chef services.
    2. Route to the jump vcn thru the LPG
 */
resource "oci_core_route_table" "service_vcn_route_table_api" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "route_table_api_${oci_core_vcn.service_vcn.display_name}"
  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.service_vcn_nat.id
  }
  route_rules {
    destination       = var.jump_vcn_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_local_peering_gateway.service_jump_lpg.id
  }
  route_rules {
    destination       = lookup(data.oci_core_services.all_oci_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_vcn_service_gateway.id
  }
}

/*
 * Route table for the Jump VCN. Should at minimum contain the following entries:
 *   1. 0.0.0.0/0 -> NAT Gateway: This is to ensure the jump instance can talk
      to services that lies outside the VCN like chef services.
    2. Route to the jump vcn thru the LPG
 */
resource "oci_core_route_table" "service_vcn_route_table_worker" {
  compartment_id = var.compartment_id_worker
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "route_table_worker_${oci_core_vcn.service_vcn.display_name}"
  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.service_vcn_nat.id
  }
  route_rules {
    destination       = var.jump_vcn_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_local_peering_gateway.service_jump_lpg.id
  }
  route_rules {
    destination       = lookup(data.oci_core_services.all_oci_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_vcn_service_gateway.id
  }
}

/*
  SecurityList for the Service VCN. Basically only allow TCP ingress for ssh at
  port 22 and the default refernce app's application port. Allows all outbound
  TCP/UDP traffic to allow the jump instance talking to other services outside
  the private network.
*/
resource "oci_core_security_list" "service_vcn_security_list" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "security_list_${oci_core_vcn.service_vcn.display_name}"

  // Allows all TCP outbound traffic
  egress_security_rules {
    destination = local.anywhere
    protocol    = local.tcp_protocol
    stateless   = false
  }
  // Allows all UDP outbound traffic
  egress_security_rules {
    destination = local.anywhere
    protocol    = local.udp_protocol
    stateless   = false
  }
  //Only allow ssh ingress traffic at port 22 and the default referenceApp's
  //application port
  ingress_security_rules {
    protocol  = local.tcp_protocol
    source    = var.jump_vcn_cidr
    stateless = false
    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    protocol  = local.tcp_protocol
    source    = var.service_vcn_cidr
    stateless = false

    tcp_options {
      min = var.host_listening_port
      max = var.host_listening_port
    }
  }
  // allow ICMP inbound traffic
  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = local.anywhere
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }

  //https://confluence.oci.oraclecorp.com/display/VS/Onboarding+to+Scan+Platform+via+Terraform
  ingress_security_rules {
    protocol  = local.icmp_protocol
    source    = oci_core_subnet.scan_platform_subnet.cidr_block
    stateless = false
  }
  ingress_security_rules {
    protocol  = local.tcp_protocol
    source    = oci_core_subnet.scan_platform_subnet.cidr_block
    stateless = false
  }
}

// Route outbound traffic to internet gateway. Also required to make public LB work.
resource "oci_core_route_table" "lb_subnet_route_table" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "route_table_lb_${oci_core_vcn.service_vcn.display_name}"
  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.lb_subnet_internet_gateway.id
  }
}

//Route table for the scan platform subnet.
resource "oci_core_route_table" "scan_platform_subnet_route_table" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "route_table_scan_platform_${oci_core_vcn.service_vcn.display_name}"
  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.service_vcn_nat.id
  }
  route_rules {
    destination       = var.jump_vcn_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_local_peering_gateway.service_jump_lpg.id
  }
}

// Allowing outbound traffic to service VCN.
resource "oci_core_security_list" "lb_subnet_security_list" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "security_list_lb_${oci_core_vcn.service_vcn.display_name}"
  egress_security_rules {
    destination = oci_core_vcn.service_vcn.cidr_block
    protocol    = local.tcp_protocol
    stateless   = false
    tcp_options {
      min = var.host_listening_port
      max = var.host_listening_port
    }
  }

  ingress_security_rules {
    protocol  = local.tcp_protocol
    source    = local.anywhere
    stateless = false
    tcp_options {
      min = var.lb_listener_port
      max = var.lb_listener_port
    }
  }
}

// The security list for scan platform.
resource "oci_core_security_list" "scan_platform_subnet_security_list" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "security_list_scan_platform_${oci_core_vcn.service_vcn.display_name}"
  egress_security_rules {
    destination = oci_core_vcn.service_vcn.cidr_block
    protocol    = local.tcp_protocol
    stateless   = false
  }
  egress_security_rules {
    destination = oci_core_vcn.service_vcn.cidr_block
    protocol    = local.icmp_protocol
    stateless   = false
  }
  egress_security_rules {
    destination = var.jump_vcn_cidr
    protocol    = local.tcp_protocol
    stateless   = false
  }
  egress_security_rules {
    destination = var.jump_vcn_cidr
    protocol    = local.icmp_protocol
    stateless   = false
  }
}

// An Internet gateway is required for public load balancers to work.
resource "oci_core_internet_gateway" "lb_subnet_internet_gateway" {
  compartment_id = var.compartment_id_api
  vcn_id         = oci_core_vcn.service_vcn.id
  display_name   = "lb_internet_gateway"
}

// A regional subnet where application runs
resource "oci_core_subnet" "service_subnet_api" {
  compartment_id             = var.compartment_id_api
  vcn_id                     = oci_core_vcn.service_vcn.id
  cidr_block                 = cidrsubnet(var.service_vcn_cidr, 1, 0)
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.service_vcn_route_table_api.id
  security_list_ids          = [oci_core_security_list.service_vcn_security_list.id]
  display_name               = "service_api_subnet_${oci_core_vcn.service_vcn.display_name}"
  dns_label                  = var.region_short
}

resource "oci_core_subnet" "service_subnet_worker" {
  compartment_id             = var.compartment_id_worker
  vcn_id                     = oci_core_vcn.service_vcn.id
  cidr_block                 = cidrsubnet(cidrsubnet(var.service_vcn_cidr, 1, 1), 1, 1)
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.service_vcn_route_table_worker.id
  security_list_ids          = [oci_core_security_list.service_vcn_security_list.id]
  display_name               = "service_worker_subnet_${oci_core_vcn.service_vcn.display_name}"
  dns_label                  = "${var.region_short}worker"
}

// Subnet for public loadbalancer.
resource "oci_core_subnet" "lb_subnet" {
  compartment_id    = var.compartment_id_api
  vcn_id            = oci_core_vcn.service_vcn.id
  cidr_block        = cidrsubnet(cidrsubnet(var.service_vcn_cidr, 1, 1), 7, 0)
  route_table_id    = oci_core_route_table.lb_subnet_route_table.id
  security_list_ids = [oci_core_security_list.lb_subnet_security_list.id]
  display_name      = "subnet_lb_${oci_core_vcn.service_vcn.display_name}"
  dns_label         = "lb"
}

// Subnet for scan platform.
resource "oci_core_subnet" "scan_platform_subnet" {
  cidr_block        = cidrsubnet(cidrsubnet(var.service_vcn_cidr, 1, 1), 7, 1)
  compartment_id    = var.compartment_id_api
  vcn_id            = oci_core_vcn.service_vcn.id
  route_table_id    = oci_core_route_table.scan_platform_subnet_route_table.id
  security_list_ids = [oci_core_security_list.scan_platform_subnet_security_list.id]
  display_name      = "subnet_scan_platform_${oci_core_vcn.service_vcn.display_name}"
  dns_label         = "scanplatform"
}

resource "scanplatform_onboarding" "onboard_scanplatform" {
  count = var.onboard_scanplatform ? 1 : 0

  onboarding_type  = "OVERLAY_INTERNAL"
  target_vcn_ocid  = oci_core_vcn.service_vcn.id
  scan_subnet_ocid = oci_core_subnet.scan_platform_subnet.id
  phonebook_id     = var.phone_book_id
}
