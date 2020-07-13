// Retrieve all available physical ADs
data "oci_identity_availability_domains" "service_ads" {
  compartment_id = local.control_plane_api_compartment_id
}

locals {
  environment                         = local.execution_target.name == "beta-us-phoenix-1" ? "beta" : "prod"
  control_plane_api_compartment_id    = module.identity.deployment_service_control_plane_api.id
  management_plane_api_compartment_id = module.identity.deployment_service_management_plane_api.id
  control_plane_worker_compartment_id = module.identity.deployment_service_control_plane_worker.id
  data_plane_worker_compartment_id    = module.identity.deployment_service_data_plane_worker.id
  bastion_compartment_id              = module.identity.deployment_bastion.id
  service_availability_domains        = [for ad in local.availability_domains : ad.name]
  service_vcn_cidr                    = "10.0.0.0/16"
  management_plane_service_vcn_cidr   = "10.2.0.0/16"
  service_name                        = "deployment-service"
  service_short_name                  = "dply-svc"
  control_plane_api_fleet_name        = "deployment-service-control-plane-api-${local.environment}"
  control_plane_worker_fleet_name     = "deployment-service-control-plane-worker-${local.environment}"
  management_plane_api_fleet_name     = "deployment-service-management-plane-api-${local.environment}"
  data_plane_worker_fleet_name        = "deployment-service-data-plane-worker-${local.environment}"
  team_queue                          = "https://jira-sd.mc1.oracleiaas.com/projects/DLCDEP"
  dns_label                           = "deploy"
  phonebook_name                      = "dlcdep"
  //Instructions to create your own host class: https://confluence.oci.oraclecorp.com/display/ICM/Creating+New+Hostclasses
  host_class              = "DLC-DEPLOYMENT-DEV-ODO"
  jira_sd_queue           = "DLCDEP"
  lb_listening_port       = 443
  api_host_listening_port = 24443

  // OverlayBastion3 Configs, for details check: https://confluence.oci.oraclecorp.com/display/OCIID/Security+Edge+Overlay+Bastion+3.0+Onboarding
  // https://jira.oci.oraclecorp.com/browse/DLCDEP-79
  ob3_bastion_cidr                = module.region_config.ob3_bastion_cidr
  ob3_jump_vcn_cidr               = module.region_config.ob3_jump_vcn_cidr
  tls_bundle_control_plane_api    = module.secret_service.tls_bundle_control_plane_api
  tls_bundle_management_plane_api = module.secret_service.tls_bundle_management_plane_api
}

module "region_config" {
  source       = "./shared_modules/region_config"
  region_short = local.execution_target.region.name
  environment  = local.execution_target.phase_name
  realm        = local.execution_target.region.realm
}

module "common" {
  source = "./shared_modules/common"
  realm  = local.execution_target.region.realm
}

# identity module
module "identity" {
  source                                                   = "./modules/identity"
  tenancy_ocid                                             = local.execution_target.tenancy_ocid
  deployment_service_control_plane_api_compartment_name    = "deployment_service_control_plane_api"
  deployment_service_management_plane_api_compartment_name = "deployment_service_management_plane_api"
  deployment_service_control_plane_worker_compartment_name = "deployment_service_control_plane_worker"
  deployment_service_data_plane_worker_compartment_name    = "deployment_service_data_plane_worker"
  bastion_compartment_name                                 = "deployment_bastion"
  limits_compartment_name                                  = "deployment_limits"
  splat_compartment_name                                   = "deployment_splat"
  secinf_tenancy_ocid                                      = module.common.secinf_tenancy_ocid
  telemetry_tenancy_ocid                                   = module.common.telemetry_tenancy_ocid
  boat_tenancy_ocid                                        = module.common.boat_tenancy_ocid
  limits_group_ocid                                        = module.common.limits_group_ocid
  odo_tenancy_ocid                                         = module.common.odo_tenancy_ocid
  service_principal_name                                   = "dlc-deployment"
}

module "image" {
  source         = "./modules/image"
  compartment_id = local.control_plane_api_compartment_id
}

module "service_network_control_plane" {
  source              = "./modules/service-network"
  region              = local.execution_target.region
  compartment_id      = local.control_plane_api_compartment_id
  service_vcn_cidr    = local.service_vcn_cidr
  jump_vcn_cidr       = local.ob3_jump_vcn_cidr
  service_name        = "${local.service_short_name}-ctrl-plane-${local.environment}"
  dns_label           = "${local.dns_label}${local.environment}"
  host_listening_port = local.api_host_listening_port
  lb_listener_port    = local.lb_listening_port
}

module "service_network_management_plane" {
  source              = "./modules/service-network"
  region              = local.execution_target.region
  compartment_id      = local.management_plane_api_compartment_id
  service_vcn_cidr    = local.management_plane_service_vcn_cidr
  jump_vcn_cidr       = local.ob3_jump_vcn_cidr
  service_name        = "${local.service_short_name}-mgmt-plane-${local.environment}"
  dns_label           = "${local.dns_label}${local.environment}"
  host_listening_port = local.api_host_listening_port
  lb_listener_port    = local.lb_listening_port
}

module "service_lb_control_plane" {
  source              = "./modules/load-balancer"
  compartment_id      = local.control_plane_api_compartment_id
  lb_shape            = "100Mbps"
  subnet_id           = module.service_network_control_plane.service_lb_subnet_id
  listener_port       = local.lb_listening_port
  host_listening_port = local.api_host_listening_port
  display_name        = "lb_${local.service_short_name}_ctrl_plane_${local.environment}"
}

module "service_lb_management_plane" {
  source              = "./modules/load-balancer"
  compartment_id      = local.management_plane_api_compartment_id
  lb_shape            = "100Mbps"
  subnet_id           = module.service_network_management_plane.service_lb_subnet_id
  listener_port       = local.lb_listening_port
  host_listening_port = local.api_host_listening_port
  display_name        = "lb_${local.service_short_name}_mgmt_plane_${local.environment}"
}

// Provision compute instances for control plane api.
module "service_instances_control_plane_api" {
  source                                = "./modules/instances"
  region                                = local.execution_target.region.public_name
  tenancy_ocid                          = local.execution_target.tenancy_ocid
  compartment_id                        = local.control_plane_api_compartment_id
  service_instance_shape                = "VM.Standard.E2.2"
  service_instance_name_prefix          = "${local.service_short_name}-ctrl-plne-api-${local.environment}"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = local.host_class
  service_instances_oci_fleet           = local.control_plane_api_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.service_network_control_plane.service_subnet_id
  attach_to_lb                          = true
  lb_backend_set_name                   = module.service_lb_control_plane.service_lb_backend_set_name
  load_balancer_id                      = module.service_lb_control_plane.service_lb_id
  application_port                      = local.api_host_listening_port
}

// Provision compute instances for control plane worker.
module "service_instances_control_plane_worker" {
  source                                = "./modules/instances"
  region                                = local.execution_target.region.public_name
  tenancy_ocid                          = local.execution_target.tenancy_ocid
  compartment_id                        = local.control_plane_worker_compartment_id
  service_instance_shape                = "VM.Standard.E2.2"
  service_instance_name_prefix          = "${local.service_short_name}-ctrl-plne-wrkr-${local.environment}"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = local.host_class
  service_instances_oci_fleet           = local.control_plane_worker_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.service_network_control_plane.service_subnet_id
  attach_to_lb                          = false
}

// Provision compute instances for management plane api.
module "service_instances_management_plane_api" {
  source                                = "./modules/instances"
  region                                = local.execution_target.region.public_name
  tenancy_ocid                          = local.execution_target.tenancy_ocid
  compartment_id                        = local.management_plane_api_compartment_id
  service_instance_shape                = "VM.Standard.E2.1"
  service_instance_name_prefix          = "${local.service_short_name}-mgmt-plne-api-${local.environment}"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = local.host_class
  service_instances_oci_fleet           = local.management_plane_api_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.service_network_management_plane.service_subnet_id
  attach_to_lb                          = true
  lb_backend_set_name                   = module.service_lb_management_plane.service_lb_backend_set_name
  load_balancer_id                      = module.service_lb_management_plane.service_lb_id
  application_port                      = local.api_host_listening_port
}

// Provision compute instances for data plane worker.
module "service_instances_data_plane_worker" {
  source                                = "./modules/instances"
  region                                = local.execution_target.region.public_name
  tenancy_ocid                          = local.execution_target.tenancy_ocid
  compartment_id                        = local.data_plane_worker_compartment_id
  service_instance_shape                = "VM.Standard.E2.1"
  service_instance_name_prefix          = "${local.service_short_name}-data-plne-wrkr-${local.environment}"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = local.host_class
  service_instances_oci_fleet           = local.data_plane_worker_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.service_network_management_plane.service_subnet_id
  attach_to_lb                          = false
}

module "lumberjack_control_plane" {
  source               = "./modules/lumberjack"
  compartment_id       = local.control_plane_api_compartment_id
  availability_domains = local.service_availability_domains
  log_namespace        = "deployment-service-control-plane"
  environment          = local.environment
}

module "lumberjack_management_plane" {
  source               = "./modules/lumberjack"
  compartment_id       = local.management_plane_api_compartment_id
  availability_domains = local.service_availability_domains
  log_namespace        = "deployment-service-management-plane"
  environment          = local.environment
}

module "secret_service" {
  source                              = "./modules/secret-service"
  control_plane_api_compartment_id    = local.control_plane_api_compartment_id
  management_plane_api_compartment_id = local.management_plane_api_compartment_id
  control_plane_api_namespace         = "deployment-service-control-plane-api-${local.environment}"
  management_plane_api_namespace      = "deployment-service-management-plane-api-${local.environment}"
  team_queue                          = local.team_queue
}

module "kiev_control_plane" {
  source         = "./modules/kiev"
  compartment_id = local.control_plane_api_compartment_id
  service_name   = "${local.service_short_name}-control-plane"
  environment    = local.environment
}

module "kiev_data_plane" {
  source         = "./modules/kiev"
  compartment_id = local.control_plane_api_compartment_id
  service_name   = "${local.service_short_name}-data-plane"
  environment    = local.environment
}

module "certificate" {
  source                               = "./modules/certificate"
  tenancy_ocid                         = local.execution_target.tenancy_ocid
  environment                          = local.environment
  control_plane_compartment_id         = local.control_plane_api_compartment_id
  management_plane_compartment_id      = local.management_plane_api_compartment_id
  phonebook_name                       = local.phonebook_name
  tls_certificate_control_plane_api    = local.tls_bundle_control_plane_api
  tls_certificate_management_plane_api = local.tls_bundle_management_plane_api
}

// https://confluence.oci.oraclecorp.com/display/OCIID/Security+Edge+Overlay+Bastion+3.0+Onboarding
module "ob3_jump" {
  source                             = "./modules/ob3-jump"
  tenancy_ocid                       = local.execution_target.tenancy_ocid
  region                             = local.execution_target.region.public_name
  bastion_compartment_id             = local.bastion_compartment_id
  ob3_bastion_cidr                   = local.ob3_bastion_cidr
  jump_vcn_cidr                      = local.ob3_jump_vcn_cidr
  jump_instance_shape                = "VM.Standard.E2.1"
  jump_instance_image_id             = module.image.overlay_image.id
  jump_instance_ad                   = data.oci_identity_availability_domains.service_ads.availability_domains[0].name
  jump_instance_hostclass            = local.host_class
  service_vcn_cidr                   = local.service_vcn_cidr
  service_vcn_lpg_id                 = module.service_network_control_plane.service_jump_lpg_id
  management_plane_service_vcn_cidr  = local.management_plane_service_vcn_cidr
  management_plane_vcn_lpg_id        = module.service_network_management_plane.service_jump_lpg_id
  bastion_lpg_requestor_tenancy_ocid = module.region_config.bastion_lpg_requestor_tenancy_ocid
  bastion_lpg_requestor_group_ocid   = module.region_config.bastion_lpg_requestor_group_ocid
}

module "dns" {
  source                                              = "./modules/dns"
  environment                                         = local.environment
  region                                              = local.execution_target.region.public_name
  control_plane_api_public_loadbalancer_ip_address    = module.service_lb_control_plane.service_public_loadbalancer_ip_address
  management_plane_api_public_loadbalancer_ip_address = module.service_lb_management_plane.service_public_loadbalancer_ip_address
}

module "limits" {
  source           = "./modules/limits"
  compartment_ocid = module.identity.deployment_limits.id
}

module "odo_application_control_plane" {
  source                           = "./modules/odo-app-pool"
  deployment_api_compartment_id    = local.control_plane_api_compartment_id
  deployment_worker_compartment_id = local.control_plane_worker_compartment_id
  availability_domains             = local.service_availability_domains
  name_prefix                      = "${local.service_name}-control-plane"
  release_name                     = local.execution_target.phase_name
  odo_application_type             = "NON_PRODUCTION"
  stage                            = local.environment
  api_instance_pools               = module.service_instances_control_plane_api.instance_pools
  worker_instance_pools            = module.service_instances_control_plane_worker.instance_pools
  api_artifact_name                = "deployment-service-control-plane-api"
  worker_artifact_name             = "deployment-service-control-plane-worker"
}

module "alarms_control_plane" {
  source                           = "./modules/alarms"
  deployment_api_compartment_id    = local.control_plane_api_compartment_id
  deployment_worker_compartment_id = local.control_plane_worker_compartment_id
  jira_sd_queue                    = local.jira_sd_queue
  fleet_name_api                   = "${local.service_name}-control-plane-api"
  fleet_name_worker                = "${local.service_name}-control-plane-worker"
}

module "odo_application_management_plane" {
  source                           = "./modules/odo-app-pool"
  deployment_api_compartment_id    = local.management_plane_api_compartment_id
  deployment_worker_compartment_id = local.data_plane_worker_compartment_id
  availability_domains             = local.service_availability_domains
  name_prefix                      = "${local.service_name}-management-plane"
  release_name                     = local.execution_target.phase_name
  odo_application_type             = "NON_PRODUCTION"
  stage                            = local.environment
  api_instance_pools               = module.service_instances_management_plane_api.instance_pools
  worker_instance_pools            = module.service_instances_data_plane_worker.instance_pools
  api_artifact_name                = "deployment-service-management-plane-api"
  worker_artifact_name             = "deployment-service-data-plane-worker"
}

module "alarms_management_plane" {
  source                           = "./modules/alarms"
  deployment_api_compartment_id    = local.management_plane_api_compartment_id
  deployment_worker_compartment_id = local.data_plane_worker_compartment_id
  jira_sd_queue                    = local.jira_sd_queue
  fleet_name_api                   = "${local.service_name}-management-plane-api"
  fleet_name_worker                = "${local.service_name}-management-plane-worker"
}
