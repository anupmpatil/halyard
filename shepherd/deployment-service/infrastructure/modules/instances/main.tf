data "ad_availability_domains" "availability_domains" {
  tenancy_id = var.tenancy_ocid
}

locals {
  ad_map             = { for ad in data.ad_availability_domains.availability_domains.ads : ad.name => ad.logical_ad }
  logical_ad_pattern = "\\w*-ad-(\\d*)"
}

resource "oci_core_instance_configuration" "instance_configuration" {
  for_each = toset(var.service_instance_availability_domains)

  compartment_id = var.compartment_id
  display_name   = "${var.service_instance_name_prefix}-ad${regex(local.logical_ad_pattern, each.value)[0]}-instance-configuration"

  instance_details {
    instance_type = "compute"
    launch_details {
      availability_domain = local.ad_map[each.value]
      compartment_id      = var.compartment_id
      shape               = var.service_instance_shape

      create_vnic_details {
        subnet_id        = var.service_subnet_id
        assign_public_ip = false
        hostname_label   = "${var.service_instance_name_prefix}-ad${regex(local.logical_ad_pattern, each.value)[0]}"
      }
      source_details {
        source_type = "image"
        image_id    = var.service_instance_image_id
      }
      metadata = {
        hostclass = var.service_instances_hostclass_name
      }
      freeform_tags = {
        "OCI:Fleet" = var.service_instances_oci_fleet
      }
    }
  }
}

// Create instance pools that manage compute instances
resource "oci_core_instance_pool" "instance_pools" {
  for_each = toset(var.service_instance_availability_domains)

  compartment_id            = var.compartment_id
  display_name              = "${var.service_instance_name_prefix}-ad${regex(local.logical_ad_pattern, each.value)[0]}"
  instance_configuration_id = oci_core_instance_configuration.instance_configuration[each.key].id
  placement_configurations {
    availability_domain = local.ad_map[each.value]
    primary_subnet_id   = var.service_subnet_id
  }
  size = var.instance_count_per_ad

  dynamic load_balancers {
    // Not iterating any collection, just don't attach LB when var.attach_to_lb is false
    for_each = [for lb in [var.attach_to_lb] : lb if lb == true]

    content {
      backend_set_name = var.lb_backend_set_name
      load_balancer_id = var.load_balancer_id
      port             = var.application_port
      vnic_selection   = "PrimaryVnic"
    }
  }

}
