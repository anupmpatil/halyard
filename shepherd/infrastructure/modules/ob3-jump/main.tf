/*
    OB3 Jump VCN. This VCN is the intermediate VCN that connects OB3 bastion
    VCN and your service VCN. Must use the CIDR block provided by SecEdge.
    Must make sure there is no CIDR block overlap between the Jump VCN and
    the service VCN.
*/
resource "oci_core_vcn" "jump_vcn" {
  cidr_block = var.jump_vcn_cidr
  compartment_id = var.bastion_compartment_id
  dns_label = "ob3jump"
  display_name = "${var.region}-vcn-ob3-jump"
}

/*
  NAT gateway is necessary here since the jump instance needs to talk to chef
  service and others to update SSH credentials.
*/
resource "oci_core_nat_gateway" "jump_vcn_nat" {
  compartment_id = var.bastion_compartment_id
  vcn_id = oci_core_vcn.jump_vcn.id
  display_name = "nat_ob3_jump"
}

// Local Peering Gateway (LPG) that should be paired to the given OB3 bastion host.
resource "oci_core_local_peering_gateway" "ob3_lpg" {
  compartment_id = var.bastion_compartment_id
  vcn_id = oci_core_vcn.jump_vcn.id
  display_name = "lpg_ob3_to_jump"
}

// LPG that pairs to your service VCN
resource "oci_core_local_peering_gateway" "service_lpg" {
  compartment_id = var.bastion_compartment_id
  vcn_id = oci_core_vcn.jump_vcn.id
  peer_id = var.service_vcn_lpg_id
  display_name = "lpg_jump_to_service"
}

// Subnet in the jump vcn that would run the jump instance.
resource "oci_core_subnet" "jump_vcn_subnet" {
  compartment_id = var.bastion_compartment_id
  vcn_id = oci_core_vcn.jump_vcn.id
  cidr_block = var.jump_vcn_cidr //Consuming all IPs in the VCN CIDR block.
  route_table_id = oci_core_route_table.jump_vcn_route_table.id
  dns_label = "ob3jump"
  prohibit_public_ip_on_vnic = true
  display_name = "${var.region}-jumpsubnet"
}

/*
* Route table for the Jump VCN. Should at minimum contain the following entries:
*   1. 0.0.0.0/0 -> NAT Gateway: This is to ensure the jump instance can talk
      to services that lies outside the VCN like chef services.
    2. Route to OB3 Bastion host thru the LPG
    3. Route to service VCN thru the LPG(s)
 */
resource "oci_core_route_table" "jump_vcn_route_table" {
  compartment_id = var.bastion_compartment_id
  vcn_id = oci_core_vcn.jump_vcn.id
  display_name = "jump_vcn_route_table"
  route_rules {
      destination = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      network_entity_id = oci_core_nat_gateway.jump_vcn_nat.id
  }
  route_rules {
      destination = var.ob3_bastion_cidr
      destination_type = "CIDR_BLOCK"
      network_entity_id = oci_core_local_peering_gateway.ob3_lpg.id
  }
  route_rules {
      destination = var.service_vcn_cidr
      destination_type = "CIDR_BLOCK"
      network_entity_id = oci_core_local_peering_gateway.service_lpg.id
  }
}

/*
  SecurityList for the Jump VCN. Basically only allow TCP ingress for ssh at
  port 22 and allows all outbound TCP/UDP traffic to allow the jump instance
  talking to other services outside the private network.
*/
resource "oci_core_security_list" "jump_vcn_security_list" {
  compartment_id = var.bastion_compartment_id
  vcn_id = oci_core_vcn.jump_vcn.id
  display_name = "bastion_jump_security_list"
  
  // Allows all TCP outbound traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
    stateless = false
  }
  // Allows all UDP outbound traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "17"
    stateless = false
  }
  //Only allow ssh ingress traffic at port 22
  ingress_security_rules {
      protocol = "6" //TCP
      source = "${coalesce(oci_core_local_peering_gateway.ob3_lpg.peer_advertised_cidr, "0.0.0.0/0")}"
      stateless = false

      tcp_options {
        min = 22
        max = 22
      }
  }
  // allow ICMP inbound traffic
  ingress_security_rules {
    protocol = "1"
    source = "0.0.0.0/0"
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }
}

// Launching the jump instance.
resource "oci_core_instance" "jump_instance" {
  compartment_id = var.bastion_compartment_id
  availability_domain = var.jump_instance_ad
  shape = var.jump_instance_shape
  display_name = var.jump_instance_display_name
  create_vnic_details {
    subnet_id = oci_core_subnet.jump_vcn_subnet.id
    assign_public_ip = false
  }
  source_details {
    source_type = "image"
    source_id = var.jump_instance_image_id
  }
  metadata = {
    hostclass = var.jump_instance_hostclass
  }
}

resource "oci_identity_policy" "bastion_policy" {
  // This ocid is for the root compartment where the policy resides
  compartment_id = var.tenancy_ocid

  // This ocid is for the bastion compartment which the lpg belongs to
  description = "bastion lpg for compartment ${var.bastion_compartment_id}"
  name           = "bastion-lpg-policy"

  statements = [
    "define tenancy Requestor as ${var.bastion_lpg_requestor_tenancy_ocid}",
    "define group RequestorGrp as ${var.bastion_lpg_requestor_group_ocid}",
    "admit group RequestorGrp of tenancy Requestor to manage local-peering-to in compartment id ${var.bastion_compartment_id}",
    "admit group RequestorGrp of tenancy Requestor to associate local-peering-gateways in tenancy Requestor with local-peering-gateways in compartment id ${var.bastion_compartment_id}"
  ]
}
