//https://confluence.oci.oraclecorp.com/display/COM/ICS+Images+Shepherd+Integration

locals {
  non_selinux_image = "E446" //OVERLAY-OL7-UEK5-75GB-CHEF
  selinux_image     = "BE24" //OVERLAY-OL7-UEK5-75GB-CHEF-SELINUX
}
