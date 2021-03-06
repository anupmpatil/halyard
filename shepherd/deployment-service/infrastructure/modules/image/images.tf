locals {
  image_name = "ol79-x86_64-lvm-20210209-UEK5-75G-C522-PV"
  image_uri  = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/El2DG1l8Bn2aEgcgfokRB38aVGYSPmvhEOW488MaedsJeHSzwh3N036RnJ7lfEfB/n/idlybogdd5kn/b/manual_tagged_images/o/ol79-x86_64-lvm-20210209-UEK5-75G-C522-PV"
}

resource "oci_core_image" "overlay_image" {
  #Required
  compartment_id = var.compartment_id
  launch_mode    = "NATIVE"

  image_source_details {
    source_type = "objectStorageUri"
    source_uri  = local.image_uri
    #Optional
    source_image_type = "VMDK"
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