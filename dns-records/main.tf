variable "environment" {
  # Defaults should never be checked-in; so as to avoid accidentally using unintended values
  #default = "prod"
  description = "Environment to get DNS records for: e.g. prod, beta, preprod"
}

variable "realm" {
  # Defaults should never be checked-in; so as to avoid accidentally using unintended values
  #default = "oc1"
  description = "Realm to get DNS records for: e.g. oc1, oc2, etc..."
}

variable "region" {
  # Defaults should never be checked-in; so as to avoid accidentally using unintended values
  #default = "us-ashburn-1"
  description = "Region to get DNS records for: e.g. us-ashburn-1"
}

locals {
  env_suffix = var.environment == "prod" ? "" : "-${var.environment}"
}

module "dnsdomain" {
  source      = "./shared_modules/dns_domain"
  environment = var.environment
  realm       = var.realm
}

module "tenancyinfo" {
  source = "./shared_modules/common_files"
}

module "ctrl_plane_lbinfo" {
  source                = "./shared_modules/svc_lb_get"
  compartment_id        = module.identity.deployment_service_control_plane_api_compartment.id
  lb_display_name_regex = "lb_dply-svc_ctrl_plane.*"
}

module "mgmt_plane_lbinfo" {
  source                = "./shared_modules/svc_lb_get"
  compartment_id        = module.identity.deployment_service_management_plane_api_compartment.id
  lb_display_name_regex = "lb_dply-svc_mgmt_plane.*"
}

module "identity" {
  source                        = "./shared_modules/identity"
  tenancy_ocid                  = module.tenancyinfo.tenancy_ocid_map[local.envOrRealm]
  canary_tenancy_ocid           = ""
  integration_test_tenancy_ocid = ""
}

locals {
  envOrRealm = var.environment != "beta" && var.environment != "preprod" ? var.realm : var.environment

  internal_domain = module.dnsdomain.oci_service_internal_endpoint_domain_new

  my_dns_record_map = {
    # CP downstream name
    "${var.environment}.control.plane.api.project-service.${var.region}.${local.internal_domain}_A" = {
      zone_name   = "${var.region}.${local.internal_domain}"
      domain_name = "${var.environment}.control.plane.api.clouddeploy.${var.region}.${local.internal_domain}"
      rtype       = "A"
      ttl         = "900"
      rdata       = module.ctrl_plane_lbinfo.deploy_lb_ip
    }
    # Old Mgmt Plane downstream name
    "${var.environment}.management.plane.api.project-service.${var.region}.${local.internal_domain}_A" = {
      zone_name   = "${var.region}.${local.internal_domain}"
      domain_name = "${var.environment}.management.plane.api.clouddeploy.${var.region}.${local.internal_domain}"
      rtype       = "A"
      ttl         = "900"
      rdata       = module.mgmt_plane_lbinfo.deploy_lb_ip
    }
    /*
    # New CP downstream name
    "downstream.deploy-cp-api${local.env_suffix}.clouddeploy.${var.region}.${local.internal_domain}_A" = {
      zone_name   = "${var.region}.${local.internal_domain}"
      domain_name = "downstream.deploy-cp-api${local.env_suffix}.clouddeploy.${var.region}.${local.internal_domain}"
      rtype       = "A"
      ttl         = "900"
      rdata       = module.ctrl_plane_lbinfo.deploy_lb_ip
    }
    # New Mgmt Plane downstream name
    "downstream.deploy-mgmt-api${local.env_suffix}.clouddeploy.${var.region}.${local.internal_domain}_A" = {
      zone_name   = "${var.region}.${local.internal_domain}"
      domain_name = "downstream.deploy-mgmt-api${local.env_suffix}.clouddeploy.${var.region}.${local.internal_domain}"
      rtype       = "A"
      ttl         = "900"
      rdata       = module.mgmt_plane_lbinfo.deploy_lb_ip
    }
    */
  }
}

resource "oci_dns_rrset" "deploy_service_dns_rrset" {
  for_each        = local.my_dns_record_map
  zone_name_or_id = each.value.zone_name
  domain          = each.value.domain_name
  rtype           = each.value.rtype
  items {
    domain = each.value.domain_name
    rtype  = each.value.rtype
    ttl    = each.value.ttl
    rdata  = each.value.rdata
  }
}