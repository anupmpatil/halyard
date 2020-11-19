locals {
  environment = length(regexall("beta", local.execution_target.name)) > 0 ? "beta" : "prod"
  team_queue  = "https://jira-sd.mc1.oracleiaas.com/projects/DLCDEP"
}

# identity module
module "identity" {
  source                                                   = "./identity"
  tenancy_ocid                                             = local.execution_target.tenancy_ocid
  deployment_service_control_plane_api_compartment_name    = "deployment_service_control_plane_api"
  deployment_service_management_plane_api_compartment_name = "deployment_service_management_plane_api"
  deployment_service_control_plane_worker_compartment_name = "deployment_service_control_plane_worker"
  deployment_service_data_plane_worker_compartment_name    = "deployment_service_data_plane_worker"
  bastion_compartment_name                                 = "deployment_bastion"
  limits_compartment_name                                  = "deployment_limits"
  splat_compartment_name                                   = "deployment_splat"
  secinf_tenancy_ocid                                      = module.identity.secinf_tenancy_ocid
  telemetry_tenancy_ocid                                   = module.identity.telemetry_tenancy_ocid
  boat_tenancy_ocid                                        = module.identity.boat_tenancy_ocid
  limits_group_ocid                                        = module.identity.limits_group_ocid
  odo_tenancy_ocid                                         = module.identity.odo_tenancy_ocid
  service_principal_name                                   = "dlc-deployment"
  griffin_agent_tenancy_ocid                               = module.identity.griffin_tenancy_ocid
  realm                                                    = local.execution_target.region.realm
  bastion_compartment_id                                   = module.identity.deployment_bastion.id
  bastion_lpg_requestor_tenancy_ocid                       = module.region_config.bastion_lpg_requestor_tenancy_ocid
  bastion_lpg_requestor_group_ocid                         = module.region_config.bastion_lpg_requestor_group_ocid
}

module "region_config" {
  source       = "./shared_modules/region_config"
  region_short = local.execution_target.region.name
  environment  = local.execution_target.phase_name
  realm        = local.execution_target.region.realm
}

module "certificate" {
  source                          = "./certificate"
  tenancy_ocid                    = local.execution_target.tenancy_ocid
  environment                     = local.environment
  control_plane_compartment_id    = module.identity.deployment_service_control_plane_api.id
  management_plane_compartment_id = module.identity.deployment_service_management_plane_api.id
  phonebook_name                  = "dlcdep"
}