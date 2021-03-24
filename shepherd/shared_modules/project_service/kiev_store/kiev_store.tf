locals {
  project_svc_cp_kiev_store_name_map = {
    "beta"    = "prj-svc-control-plane-dev"
    "preprod" = "prj-svc-control-plane-preprod"
    "prod"    = "prj-svc-cp-production"
  }
}

module "project_svc_tenancy" {
  source      = "../tenancy"
  realm       = var.realm
  environment = var.environment
}

data "kaas_regional_instance" "project_svc_kaas" {
  compartment_id = module.project_svc_tenancy.project_svc_cp_compartment_id
  kiev_name      = lookup(local.project_svc_cp_kiev_store_name_map, var.environment, "not_defined")
}

locals {
  project_svc_cp_kiev_endpoint = data.kaas_regional_instance.project_svc_kaas.dns
}

output "project_svc_cp_kiev_store_name" {
  value = lookup(local.project_svc_cp_kiev_store_name_map, var.environment, "not_defined")
}

output "project_svc_cp_kiev_endpoint" {
  value = "https://${local.project_svc_cp_kiev_endpoint}"
}

