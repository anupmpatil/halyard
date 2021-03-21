output "image_type" {
  value = ((var.realm == "oc1" && contains(local.oc1_non_selinux_regions, var.region)) || (var.realm == "oc4" && contains(local.oc4_non_selinux_regions, var.region))) ? local.non_selinux_image : local.selinux_image
}