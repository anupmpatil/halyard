locals {
  image_name = "ol79-x86_64-lvm-20201014-UEK5-75G-00F6-PV"
  image_uri  = "https://objectstorage.us-phoenix-1.oraclecloud.com/p/Tzut-zRU24r6wq9UGQs17Dn-cfYK06chggQrKl0HRviuXLydlT97Rv18p1a8hCJc/n/idlybogdd5kn/b/manual_tagged_images/o/ol79-x86_64-lvm-20201014-UEK5-75G-00F6-PV"
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