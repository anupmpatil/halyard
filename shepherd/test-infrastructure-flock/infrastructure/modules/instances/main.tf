data "ad_availability_domains" "availability_domains" {
  tenancy_id = var.tenancy_ocid
}

locals {
  ad_map             = { for ad in data.ad_availability_domains.availability_domains.ads : ad.name => ad.logical_ad }
  logical_ad_pattern = "\\w*-ad-(\\d*)"
}

resource "oci_core_instance" "instance_group" {
  for_each = toset(var.service_instance_availability_domains)

  compartment_id = var.compartment_id
  display_name   = "${var.service_instance_name_prefix}-ad${regex(local.logical_ad_pattern, each.value)[0]}-instance"


  availability_domain = local.ad_map[each.value]
  shape               = var.service_instance_shape
  shape_config { ocpus = var.instance_shape_config.ocpus }

  create_vnic_details {
    subnet_id        = var.service_subnet_id
    assign_public_ip = false
    hostname_label   = "${var.service_instance_name_prefix}-ad${regex(local.logical_ad_pattern, each.value)[0]}"
  }
  source_details {
    source_type = "image"
    source_id   = var.service_instance_image_id
  }
  //metadata = {
  //  hostclass = var.service_instances_hostclass_name
  //}
}
