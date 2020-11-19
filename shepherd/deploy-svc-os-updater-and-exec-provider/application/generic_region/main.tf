# Os-updater deployments
# We can deploy to these using their aliases, which are defined in the main flock.

data "oci_identity_availability_domains" "service_ads" {
  compartment_id = local.execution_target.tenancy_ocid
}

locals {
  et = local.execution_target
  ad = [for ad in local.availability_domains : ad.name]

  # Combined map:
  aliases = {
    management_plane = "deployment-service-management-plane-os-updater-beta"
    control_plane    = "deployment-service-control-plane-os-updater-beta"
    bastion          = "deployment-service-bastion-os-updater-beta"
  }
}

module "deployment_service_integration_tests" {
  source               = "./modules/exec-provider-integration-tests"
  availability_domains = local.ad
  artifact_versions    = local.artifact_versions
  compartment_id       = local.execution_target.tenancy_ocid
  artifact_name        = "deployment-service-integration-test"
}

module "deployment_service_os_updater" {
  source                = "./modules/os-updater"
  availability_domains  = local.ad
  artifact_versions     = local.artifact_versions
  artifact_name         = "odo-system-updater"
  odo_app_alias_mp      = local.aliases.management_plane
  odo_app_alias_cp      = local.aliases.control_plane
  odo_app_alias_bastion = local.aliases.bastion
}