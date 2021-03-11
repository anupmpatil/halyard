locals {
  environment                         = lookup(module.environment_config.environment_name_map, local.execution_target.phase_name, "beta")
  control_plane_api_compartment_id    = module.identity.deployment_service_control_plane_api_compartment.id
  management_plane_api_compartment_id = module.identity.deployment_service_management_plane_api_compartment.id
  control_plane_worker_compartment_id = module.identity.deployment_service_control_plane_worker_compartment.id
  data_plane_worker_compartment_id    = module.identity.deployment_service_data_plane_worker_compartment.id
  bastion_compartment_id              = module.identity.bastion_compartment.id
  canary_test_compartment_id          = module.identity.canary_test_compartment.id
  integration_test_compartment_id     = module.identity.integration_test_compartment.id
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
  instance_shape                      = "VM.Standard.E3.Flex"
  region_short_name                   = lookup(module.environment_config.region_short_name_map, local.execution_target.region.name, "phx")
  t2_project_name                     = module.t2_config.t2_project_name
  //Instructions to create your own host class: https://confluence.oci.oraclecorp.com/display/ICM/Creating+New+Hostclasses
  host_classes            = local.environment != "prod" ? module.network_config.oci_host_classes_dev_map : module.network_config.oci_host_classes_prod_map
  jira_sd_queue           = "DLCDEP"
  lb_listening_port       = 443
  api_host_listening_port = 24443

  // OverlayBastion3 Configs, for details check: https://confluence.oci.oraclecorp.com/display/OCIID/Security+Edge+Overlay+Bastion+3.0+Onboarding
  // https://jira.oci.oraclecorp.com/browse/DLCDEP-79
  ob3_bastion_cidr  = module.network_config.ob3_bastion_cidr
  ob3_jump_vcn_cidr = module.network_config.ob3_jump_vcn_cidr

  project_svc_cp_compartment_id = module.project_service.project_svc_cp_compartment_id
  project_svc_cp_kiev_endpoint  = module.project_service.project_svc_cp_kiev_endpoint

  project_svc_cp_kiev_store_name = module.project_service.project_svc_cp_kiev_store_name
  data_plane_kiev_store_name     = "${local.service_short_name}-data-plane-${local.environment}"
}

module "tenancies" {
  source = "./shared_modules/common_files"
}

module "identity" {
  source                        = "./shared_modules/identity"
  canary_tenancy_ocid           = lookup(module.tenancies.canary_test_tenancy_ocid_map, local.execution_target.phase_name, "not_defined")
  tenancy_ocid                  = local.execution_target.tenancy_ocid
  integration_test_tenancy_ocid = lookup(module.tenancies.integ_test_tenancy_ocid_map, local.execution_target.phase_name, "not_defined")
}

module "project_service" {
  source      = "./shared_modules/project_service"
  environment = local.environment
}

module "environment_config" {
  source = "./shared_modules/common_files"
}

module "t2_config" {
  source = "./shared_modules/common_files"
}

module "network_config" {
  source       = "./shared_locals/network"
  region_short = local.region_short_name
  environment  = local.execution_target.phase_name
  realm        = local.execution_target.region.realm
}

module "image" {
  source         = "./modules/image"
  compartment_id = local.control_plane_api_compartment_id
}

module "scanplatform" {
  source = "./shared_locals/scanplatform"
  realm  = local.execution_target.region.realm
}

module "wfaasconfig" {
  source      = "./shared_modules/wfaas_config"
  environment = local.environment
}

module "dnsdomain" {
  source      = "./shared_modules/dns_domain"
  environment = local.environment
  realm       = local.execution_target.region.realm
}

module "service_network_control_plane" {
  source                = "./modules/service-network"
  region                = local.execution_target.region
  compartment_id_api    = local.control_plane_api_compartment_id
  compartment_id_worker = local.control_plane_worker_compartment_id
  service_vcn_cidr      = local.service_vcn_cidr
  jump_vcn_cidr         = local.ob3_jump_vcn_cidr
  service_name          = "${local.service_short_name}-ctrl-plane-${local.environment}"
  dns_label             = "${local.dns_label}${local.environment}"
  host_listening_port   = local.api_host_listening_port
  lb_listener_port      = local.lb_listening_port
  region_short          = local.region_short_name
  onboard_scanplatform  = contains(module.scanplatform.scanplatform_supported_regions, local.execution_target.region.public_name)
  phone_book_id         = local.phonebook_name
}

module "service_network_management_plane" {
  source                = "./modules/service-network"
  region                = local.execution_target.region
  compartment_id_api    = local.management_plane_api_compartment_id
  compartment_id_worker = local.data_plane_worker_compartment_id
  service_vcn_cidr      = local.management_plane_service_vcn_cidr
  jump_vcn_cidr         = local.ob3_jump_vcn_cidr
  service_name          = "${local.service_short_name}-mgmt-plane-${local.environment}"
  dns_label             = "${local.dns_label}${local.environment}"
  host_listening_port   = local.api_host_listening_port
  lb_listener_port      = local.lb_listening_port
  region_short          = local.region_short_name
  onboard_scanplatform  = contains(module.scanplatform.scanplatform_supported_regions, local.execution_target.region.public_name)
  phone_book_id         = local.phonebook_name
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
  service_instance_shape                = local.environment == "beta" ? "VM.Standard.E2.1" : local.instance_shape
  instance_shape_config                 = { ocpus = 1 }
  service_instance_name_prefix          = "${local.service_short_name}-ctrl-plne-api-${local.environment}"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = local.host_classes["dep-service-cp-api"]
  service_instances_oci_fleet           = local.control_plane_api_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.service_network_control_plane.service_subnet_api_id
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
  service_instance_shape                = local.environment == "beta" ? "VM.Standard.E2.1" : local.instance_shape
  instance_shape_config                 = { ocpus = 1 }
  service_instance_name_prefix          = "${local.service_short_name}-ctrl-plne-wrkr-${local.environment}"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = local.host_classes["dep-service-cp-worker"]
  service_instances_oci_fleet           = local.control_plane_worker_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.service_network_control_plane.service_subnet_worker_id
  attach_to_lb                          = false
}

// Provision compute instances for management plane api.
module "service_instances_management_plane_api" {
  source                                = "./modules/instances"
  region                                = local.execution_target.region.public_name
  tenancy_ocid                          = local.execution_target.tenancy_ocid
  compartment_id                        = local.management_plane_api_compartment_id
  service_instance_shape                = local.environment == "beta" ? "VM.Standard.E2.2" : local.instance_shape
  instance_shape_config                 = { ocpus = 2 }
  service_instance_name_prefix          = "${local.service_short_name}-mgmt-plne-api-${local.environment}"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = local.host_classes["dep-service-mgt-api"]
  service_instances_oci_fleet           = local.management_plane_api_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.service_network_management_plane.service_subnet_api_id
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
  service_instance_shape                = local.environment == "beta" ? "VM.Standard.E2.2" : local.instance_shape
  instance_shape_config                 = { ocpus = 2 }
  service_instance_name_prefix          = "${local.service_short_name}-data-plne-wrkr-${local.environment}"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = local.host_classes["dep-service-dp-worker"]
  service_instances_oci_fleet           = local.data_plane_worker_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.service_network_management_plane.service_subnet_worker_id
  attach_to_lb                          = false
}

module "lumberjack_control_plane" {
  source                = "./modules/lumberjack"
  api_compartment_id    = local.control_plane_api_compartment_id
  worker_compartment_id = local.control_plane_worker_compartment_id
  availability_domains  = local.service_availability_domains
  log_namespace_api     = "deployment-service-control-plane"
  log_namespace_worker  = "deployment-service-control-plane"
  environment           = local.environment
}

module "lumberjack_management_plane" {
  source                = "./modules/lumberjack"
  api_compartment_id    = local.management_plane_api_compartment_id
  worker_compartment_id = local.data_plane_worker_compartment_id
  availability_domains  = local.service_availability_domains
  log_namespace_api     = "deployment-service-management-plane"
  log_namespace_worker  = "deployment-service-data-plane"
  environment           = local.environment
}

module "secret_service" {
  source                              = "./modules/secret-service"
  control_plane_api_compartment_id    = local.control_plane_api_compartment_id
  management_plane_api_compartment_id = local.management_plane_api_compartment_id
  control_plane_api_namespace         = "deployment-service-control-plane-api-${local.environment}"
  management_plane_api_namespace      = "deployment-service-management-plane-api-${local.environment}"
  team_queue                          = local.team_queue
}

module "kiev_data_plane" {
  source          = "./modules/kiev"
  compartment_id  = local.management_plane_api_compartment_id
  service_name    = "${local.service_short_name}-data-plane"
  kiev_store_name = local.data_plane_kiev_store_name
  environment     = local.environment
  phone_book_name = local.phonebook_name
}

// https://confluence.oci.oraclecorp.com/display/OCIID/Security+Edge+Overlay+Bastion+3.0+Onboarding
module "ob3_jump" {
  source                                = "./modules/ob3-jump"
  tenancy_ocid                          = local.execution_target.tenancy_ocid
  region                                = local.execution_target.region.public_name
  bastion_compartment_id                = local.bastion_compartment_id
  ob3_bastion_cidr                      = local.ob3_bastion_cidr
  jump_vcn_cidr                         = local.ob3_jump_vcn_cidr
  jump_instance_shape                   = local.environment == "beta" ? "VM.Standard.E2.1" : local.instance_shape
  jump_instance_image_id                = module.image.overlay_image.id
  jump_instance_hostclass               = local.host_classes["dep-service-bastion"]
  service_vcn_cidr                      = local.service_vcn_cidr
  service_vcn_lpg_id                    = module.service_network_control_plane.service_jump_lpg_id
  service_vcn_scan_subnet_cidr          = module.service_network_control_plane.scan_subnet_cidr
  scan_subnet_id                        = module.service_network_control_plane.scan_subnet_id
  management_plane_service_vcn_cidr     = local.management_plane_service_vcn_cidr
  management_plane_vcn_lpg_id           = module.service_network_management_plane.service_jump_lpg_id
  management_plane_vcn_scan_subnet_cidr = module.service_network_management_plane.scan_subnet_cidr
  onboard_scanplatform                  = contains(module.scanplatform.scanplatform_supported_regions, local.execution_target.region.public_name)
  phone_book_id                         = local.phonebook_name
  name_prefix                           = "${local.service_name}-bastion"
  release_name                          = local.execution_target.phase_name
  odo_application_type                  = "NON_PRODUCTION"
  stage                                 = local.environment
}

# DNS Management is only available using the API systems such as CLI, REST, SDK and Terraform.
# DNS Management via Console is prohibited and Shepherd DNS creation is not currently available.
# Reference: https://confluence.oci.oraclecorp.com/display/DNS/Self-Service+Internet+DNS%3A+FAQs#SelfServiceInternetDNS:FAQs-CanIuseShepherdtomanagemyinternetDNS?
# For now, use the Terraform configs in 'dns-records' directory to manage records
module "dns" {
  source                                              = "./modules/dns"
  environment                                         = local.environment
  region                                              = local.execution_target.region.public_name
  control_plane_api_public_loadbalancer_ip_address    = module.service_lb_control_plane.service_public_loadbalancer_ip_address
  management_plane_api_public_loadbalancer_ip_address = module.service_lb_management_plane.service_public_loadbalancer_ip_address
}

module "limits" {
  source           = "./modules/limits"
  compartment_ocid = module.identity.limits_compartment.id
}

module "odo_application_control_plane" {
  source                              = "./modules/odo-app-pool"
  deployment_api_compartment_id       = local.control_plane_api_compartment_id
  deployment_worker_compartment_id    = local.control_plane_worker_compartment_id
  availability_domains                = local.availability_domains
  name_prefix                         = "${local.service_name}-control-plane"
  name_prefix_worker                  = "${local.service_name}-control-plane"
  release_name                        = local.execution_target.phase_name
  odo_application_type                = local.environment == "prod" ? "PRODUCTION" : "NON_PRODUCTION"
  stage                               = local.environment
  api_instance_pools                  = module.service_instances_control_plane_api.instance_pools
  worker_instance_pools               = module.service_instances_control_plane_worker.instance_pools
  api_artifact_name                   = "deployment-service-control-plane-api"
  worker_artifact_name                = "deployment-service-control-plane-worker"
  tenancy_ocid                        = local.execution_target.tenancy_ocid
  management_plane_api_compartment_id = local.management_plane_api_compartment_id
  control_plane_api_compartment_id    = local.control_plane_api_compartment_id
  cp_worker_compartment_id            = local.control_plane_worker_compartment_id
  dp_worker_compartment_id            = local.data_plane_worker_compartment_id
  project_svc_cp_compartment_id       = local.project_svc_cp_compartment_id
  control_plane_kiev_endpoint         = local.project_svc_cp_kiev_endpoint
  data_plane_kiev_endpoint            = module.kiev_data_plane.kiev_endpoint
  control_plane_kiev_store_name       = local.project_svc_cp_kiev_store_name
  data_plane_kiev_store_name          = local.data_plane_kiev_store_name
  cp_wfaas_name                       = module.wfaasconfig.cp_wfaas_name
  dp_wfaas_name                       = module.wfaasconfig.dp_wfaas_name
  region_internal_name                = local.execution_target.region.internal_name
  oci_service_internal_domain_name    = module.dnsdomain.oci_service_internal_endpoint_domain
}

module "alarms_control_plane" {
  source                           = "./modules/alarms"
  deployment_api_compartment_id    = local.control_plane_api_compartment_id
  deployment_worker_compartment_id = local.control_plane_worker_compartment_id
  jira_sd_queue                    = local.jira_sd_queue
  fleet_name_api                   = "${local.service_name}-control-plane-api"
  fleet_name_worker                = "${local.service_name}-control-plane-worker"
  t2_project_name                  = local.t2_project_name
}

module "odo_application_management_plane" {
  source                              = "./modules/odo-app-pool"
  deployment_api_compartment_id       = local.management_plane_api_compartment_id
  deployment_worker_compartment_id    = local.data_plane_worker_compartment_id
  availability_domains                = local.availability_domains
  name_prefix                         = "${local.service_name}-management-plane"
  name_prefix_worker                  = "${local.service_name}-data-plane"
  release_name                        = local.execution_target.phase_name
  odo_application_type                = local.environment == "prod" ? "PRODUCTION" : "NON_PRODUCTION"
  stage                               = local.environment
  api_instance_pools                  = module.service_instances_management_plane_api.instance_pools
  worker_instance_pools               = module.service_instances_data_plane_worker.instance_pools
  api_artifact_name                   = "deployment-service-management-plane-api"
  worker_artifact_name                = "deployment-service-data-plane-worker"
  tenancy_ocid                        = local.execution_target.tenancy_ocid
  management_plane_api_compartment_id = local.management_plane_api_compartment_id
  control_plane_api_compartment_id    = local.control_plane_api_compartment_id
  cp_worker_compartment_id            = local.control_plane_worker_compartment_id
  dp_worker_compartment_id            = local.data_plane_worker_compartment_id
  project_svc_cp_compartment_id       = local.project_svc_cp_compartment_id
  control_plane_kiev_endpoint         = local.project_svc_cp_kiev_endpoint
  data_plane_kiev_endpoint            = module.kiev_data_plane.kiev_endpoint
  control_plane_kiev_store_name       = local.project_svc_cp_kiev_store_name
  data_plane_kiev_store_name          = local.data_plane_kiev_store_name
  cp_wfaas_name                       = module.wfaasconfig.cp_wfaas_name
  dp_wfaas_name                       = module.wfaasconfig.dp_wfaas_name
  region_internal_name                = local.execution_target.region.internal_name
  oci_service_internal_domain_name    = module.dnsdomain.oci_service_internal_endpoint_domain
}

module "alarms_management_plane" {
  source                           = "./modules/alarms"
  deployment_api_compartment_id    = local.management_plane_api_compartment_id
  deployment_worker_compartment_id = local.data_plane_worker_compartment_id
  jira_sd_queue                    = local.jira_sd_queue
  fleet_name_api                   = "${local.service_name}-management-plane-api"
  fleet_name_worker                = "${local.service_name}-management-plane-worker"
  t2_project_name                  = local.t2_project_name
}

module "wfaas_control_plane" {
  source                           = "./modules/wfaas"
  wfaas_name                       = module.wfaasconfig.cp_wfaas_name
  deployment_worker_compartment_id = local.control_plane_worker_compartment_id
  availability_domains             = local.service_availability_domains
  type                             = "AD_LOCAL"
  cell                             = "overlay"
}

module "wfaas_data_plane" {
  source                           = "./modules/wfaas"
  wfaas_name                       = module.wfaasconfig.dp_wfaas_name
  deployment_worker_compartment_id = local.data_plane_worker_compartment_id
  availability_domains             = local.service_availability_domains
  type                             = "AD_LOCAL"
  cell                             = "overlay"
}

module "rqs" {
  source                          = "./modules/rqs"
  control_plane_compartment_id    = local.control_plane_api_compartment_id
  management_plane_compartment_id = local.management_plane_api_compartment_id
  environment                     = local.environment
  phone_book_id                   = local.phonebook_name
}

module "operations" {
  source                          = "./modules/operations"
  canary_test_compartment_id      = local.canary_test_compartment_id
  integration_test_compartment_id = local.integration_test_compartment_id
}

