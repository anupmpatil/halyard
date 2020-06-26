data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "shepherd_remote_state/infrastructure.tfstate"
  }
}

locals {
  control_plane_worker_compartment_id = data.terraform_remote_state.infra.outputs.deployment_service_control_plane_worker.id
  control_plane_api_compartment_id    = data.terraform_remote_state.infra.outputs.deployment_service_control_plane_api.id
  control_plane_api_instance_pools    = data.terraform_remote_state.infra.outputs.control_plane_api_instance_pools
  control_plane_worker_instance_pools = data.terraform_remote_state.infra.outputs.control_plane_worker_instance_pools
  app_availability_domains            = data.terraform_remote_state.infra.outputs.availability_domains
  application_name                    = "deployment-service"
}

module "odo_application" {
  source                            = "./modules/odo-3ad"
  deployment_api_compartment_id     = local.control_plane_api_compartment_id
  deployment_worker_compartment_id  = local.control_plane_worker_compartment_id
  availability_domains              = local.app_availability_domains
  name_prefix                       = local.application_name
  release_name                      = local.execution_target.phase_name
  odo_application_type              = "NON_PRODUCTION"
  stage                             = "beta"
  deployment_parallelism_percentage = 100
  api_instance_pools                = local.control_plane_api_instance_pools
  worker_instance_pools             = local.control_plane_worker_instance_pools
  artifact_versions                 = local.artifact_versions
}

module "alarms" {
  source                           = "./modules/alarms"
  deployment_api_compartment_id    = local.control_plane_api_compartment_id
  deployment_worker_compartment_id = local.control_plane_worker_compartment_id
  jira_sd_queue                    = "DLCDEP"
}
