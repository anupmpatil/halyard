locals {
  image_name = "ol77-x86_64-lvm-20200420-UEK575GB-5AD7-PV"
  image_uri  = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/EmadslmoXDXqE1RItnCd7Pt10-UHEqcO0_yuqK_lpCc/n/idlybogdd5kn/b/manual_tagged_images/o/ol77-x86_64-lvm-20200420-UEK575GB-5AD7-PV"
}

resource "oci_core_image" "overlay_image" {
  #Required
  compartment_id = var.compartment_id
  #Optional
  display_name = local.image_name
  launch_mode  = "NATIVE"

  image_source_details {
    source_type = "objectStorageUri"
    source_uri  = local.image_uri
    #Optional
    source_image_type = "VMDK"
  }
}

# export
output "overlay_image" {
  value = oci_core_image.overlay_image
}