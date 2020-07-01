locals {
  zone_name = "${var.region}.oci.oracleiaas.com"
}

resource "oci_dns_record" "deployment_service_control_plane_api_public_dns" {
  zone_name_or_id = local.zone_name
  domain          = "${var.environment}.control.plane.api.clouddeploy.${local.zone_name}"
  rtype           = "A"
  rdata           = var.control_plane_api_public_loadbalancer_ip_address
  ttl             = "900"
}

resource "oci_dns_record" "deployment_service_management_plane_api_public_dns" {
  zone_name_or_id = local.zone_name
  domain          = "${var.environment}.management.plane.api.clouddeploy.${local.zone_name}"
  rtype           = "A"
  rdata           = var.management_plane_api_public_loadbalancer_ip_address
  ttl             = "900"
}