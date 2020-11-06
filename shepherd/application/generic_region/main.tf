data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "shepherd_remote_state/infrastructure.tfstate"
  }
}

locals {
  control_plane_api_application           = data.terraform_remote_state.infra.outputs.control_plane_api_application
  control_plane_worker_application        = data.terraform_remote_state.infra.outputs.control_plane_worker_application
  control_plane_os_updater_application    = data.terraform_remote_state.infra.outputs.control_plane_os_updater_application
  management_plane_api_application        = data.terraform_remote_state.infra.outputs.management_plane_api_application
  data_plane_worker_application           = data.terraform_remote_state.infra.outputs.data_plane_worker_application
  management_plane_os_updater_application = data.terraform_remote_state.infra.outputs.management_plane_os_updater_application
  app_availability_domains                = data.terraform_remote_state.infra.outputs.availability_domains
}

module "odo_deployment_control_plane" {
  source                     = "./modules/odo-deployment-3ad"
  availability_domains       = local.app_availability_domains
  artifact_versions          = local.artifact_versions
  api_artifact_name          = "deployment-service-control-plane-api"
  worker_artifact_name       = "deployment-service-control-plane-worker"
  odo_api_application        = local.control_plane_api_application
  odo_worker_application     = local.control_plane_worker_application
  odo_os_updater_application = local.control_plane_os_updater_application
}

module "odo_deployment_management_plane" {
  source                     = "./modules/odo-deployment-3ad"
  availability_domains       = local.app_availability_domains
  artifact_versions          = local.artifact_versions
  api_artifact_name          = "deployment-service-management-plane-api"
  worker_artifact_name       = "deployment-service-data-plane-worker"
  odo_api_application        = local.management_plane_api_application
  odo_worker_application     = local.data_plane_worker_application
  odo_os_updater_application = local.management_plane_os_updater_application
}

module "deployment_service_integration_tests" {
  source               = "./modules/exec-provider-integration-tests"
  availability_domains = local.app_availability_domains
  artifact_versions    = local.artifact_versions
  compartment_id       = local.execution_target.tenancy_ocid
  artifact_name        = "deployment-service-integration-test"
}
