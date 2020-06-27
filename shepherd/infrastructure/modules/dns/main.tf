locals {
  zone_name = "${var.region}.oci.oracleiaas.com"
}

resource "oci_dns_record" "api_service_public_dns" {
  zone_name_or_id = local.zone_name
  domain          = "beta.api.service.clouddeploy.${local.zone_name}"
  rtype           = "A"
  rdata           = var.api_service_public_loadbalancer_ip_address
  ttl             = "900"
}