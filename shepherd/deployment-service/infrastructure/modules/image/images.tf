/*
Ref: https://confluence.oci.oraclecorp.com/display/COM/ICS+Images+Shepherd+Integration
*/
data "tenancylookup_ocid" "ics" {
  name = "ics"
}

data "oci_identity_compartments" "compartments" {
  compartment_id = data.tenancylookup_ocid.ics.id
  filter {
    name   = "name"
    values = ["ics-image-releases"]
  }
}

data "oci_core_images" "ics_images" {
  # Required
  compartment_id = data.oci_identity_compartments.compartments.compartments[0].id
  state          = "AVAILABLE"
  sort_by        = "TIMECREATED"
  sort_order     = "DESC"
  filter {
    name   = "defined_tags.ics_images.type"
    values = [var.image_type]
  }
  filter {
    name   = "defined_tags.ics_images.release"
    values = ["LATEST"]
  }
}

resource "oci_core_image" "overlay_image" {
  # Required
  compartment_id = var.compartment_id
  image_source_details {
    source_type = "objectStorageUri"
    source_uri  = data.oci_core_images.ics_images.images[0].defined_tags["ics_images.PAR"]
  }

  # You need to ignore the image source details if you don't want to apply any changes to old images.
  lifecycle {
    ignore_changes = [
      image_source_details
    ]
  }
}

# export
output "overlay_image" {
  value = oci_core_image.overlay_image
}