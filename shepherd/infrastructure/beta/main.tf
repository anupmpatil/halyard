// Retrieve all available physical ADs
data "oci_identity_availability_domains" "service_ads" {
  compartment_id = local.api_compartment_id
}

locals {
  api_compartment_id = module.identity.deployment_api_service_beta.id
  worker_compartment_id = module.identity.deployment_worker_service_beta.id
  bastion_compartment_id = module.identity.deployment_bastion_beta.id
  service_availability_domains = [for ad in local.availability_domains : ad.name]
  service_vcn_cidr = "10.0.0.0/16"
  service_name = "deployment-service"
  service_short_name = "dply-svc"
  api_fleet_name = "deployment-service-api-beta"
  worker_fleet_name = "deployment-service-worker-beta"
  team_queue = "https://jira-sd.mc1.oracleiaas.com/projects/deployment-service"
  dns_label = "deploy"
  phonebook_name = "dlcdep"
  //Instructions to create your own host class: https://confluence.oci.oraclecorp.com/display/ICM/Creating+New+Hostclasses
  host_class = "DLC-DEPLOYMENT-DEV-ODO"

  lb_listening_port = 443
  api_host_listening_port = 24443

  /*
    OverlayBastion3 Configs, for details check: https://confluence.oci.oraclecorp.com/display/OCIID/Security+Edge+Overlay+Bastion+3.0+Onboarding
  */
  // https://jira.oci.oraclecorp.com/browse/DLCDEP-79
  ob3_bastion_cidr = module.region_config.ob3_bastion_cidr
  ob3_jump_vcn_cidr = module.region_config.ob3_jump_vcn_cidr 
  tls_certificate = module.secret_service.tls_certificate
}

module "region_config" {
  source = "./shared_modules/region_config"
  region_short = local.execution_target.region.name
  environment = local.execution_target.phase_name
  realm = local.execution_target.region.realm
}

module "common" {
  source = "./shared_modules/common"
  realm = local.execution_target.region.realm
}

# identity module
module "identity" {
  source = "./modules/identity"
  # getting tenancy ocid from ET
  tenancy_ocid = local.execution_target.tenancy_ocid
  deployment_api_compartment_name = "deployment_api_service_beta"
  worker_compartment_name = "deployment_worker_service_beta"
  bastion_compartment_name = "deployment_bastion_beta"
  limits_compartment_name = "deployment_limits_beta"
  splat_compartment_name = "deployment_splat_beta"
  secinf_tenancy_ocid = module.common.secinf_tenancy_ocid
  telemetry_tenancy_ocid = module.common.telemetry_tenancy_ocid
  boat_tenancy_ocid = module.common.boat_tenancy_ocid
  limits_group_ocid = module.common.limits_group_ocid
  odo_tenancy_ocid = module.common.odo_tenancy_ocid
}

module "image" {
  source = "./modules/image"
  compartment_id = local.api_compartment_id
}

// Provision network resources for the service.
module "service_network" {
  source = "./modules/service-network"

  region = local.execution_target.region
  compartment_id = local.api_compartment_id
  service_vcn_cidr = local.service_vcn_cidr
  jump_vcn_cidr = local.ob3_jump_vcn_cidr
  service_name =  "${local.service_short_name}-beta"
  dns_label = "${local.dns_label}beta"
  host_listening_port = local.api_host_listening_port
  lb_listener_port = local.lb_listening_port
}

// Provision load balancer related resources.
module "service_lb" {
  source = "./modules/load-balancer"

  compartment_id = local.api_compartment_id
  lb_shape = "100Mbps"
  subnet_id = module.service_network.service_lb_subnet_id
  listener_port = local.lb_listening_port
  host_listening_port = local.api_host_listening_port
  display_name = "lb_${local.service_short_name}_beta"
}

// Provision compute instances for api.
module "service_instances_api" {
  source = "./modules/instances"

  region = local.execution_target.region.public_name
  tenancy_ocid = local.execution_target.tenancy_ocid
  compartment_id = local.api_compartment_id
  service_instance_shape = "VM.Standard.E2.2"
  service_instance_name_prefix = "${local.service_short_name}-api-beta"
  service_instance_image_id = module.image.overlay_image.id
  service_instances_hostclass_name = local.host_class
  service_instances_oci_fleet = local.api_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad = 1 // TODO: Set this to your desired fleet size.
  service_subnet_id = module.service_network.service_subnet_id
  attach_to_lb = true
  lb_backend_set_name = module.service_lb.service_lb_backend_set_name
  load_balancer_id = module.service_lb.service_lb_id
  application_port = local.api_host_listening_port
}

// Provision compute instances for worker.
module "service_instances_worker" {
  source = "./modules/instances"

  region = local.execution_target.region.public_name
  tenancy_ocid = local.execution_target.tenancy_ocid
  compartment_id = local.worker_compartment_id
  service_instance_shape = "VM.Standard.E2.2"
  service_instance_name_prefix = "${local.service_short_name}-worker-beta"
  service_instance_image_id = module.image.overlay_image.id
  service_instances_hostclass_name = local.host_class
  service_instances_oci_fleet = local.worker_fleet_name
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad = 1 // TODO: Set this to your desired  fleet size.
  service_subnet_id = module.service_network.service_subnet_id
  attach_to_lb = false
}

module "lumberjack" {
  source = "./modules/lumberjack"

  compartment_id = local.api_compartment_id
  availability_domains = local.service_availability_domains
  log_namespace = "deployment-service"
  stage = "beta"
}

module "secret_service" {
  source = "./modules/secret-service"

  compartment_id = local.api_compartment_id
  name_space = "deployment-service-api-beta"
  team_queue = local.team_queue
}

module "kiev" {
  source = "./modules/kiev"

  compartment_id = local.api_compartment_id
  service_name = local.service_short_name
  stage = "beta"
}

module "certificate" {
  source = "./modules/certificate"

  tenancy_ocid = local.execution_target.tenancy_ocid
  compartment_id = local.api_compartment_id
  phonebook_name = local.phonebook_name
  tls_certificate = local.tls_certificate
}

// Uncomment this block after finished onboarding OB3:
// https://confluence.oci.oraclecorp.com/display/OCIID/Security+Edge+Overlay+Bastion+3.0+Onboarding

module "ob3_jump" {
  source = "./modules/ob3-jump"
  
  tenancy_ocid = local.execution_target.tenancy_ocid
  region = local.execution_target.region.public_name
  bastion_compartment_id = local.bastion_compartment_id
  ob3_bastion_cidr = local.ob3_bastion_cidr
  jump_vcn_cidr = local.ob3_jump_vcn_cidr
  jump_instance_shape = "VM.Standard.E2.1"
  jump_instance_image_id = module.image.overlay_image.id
  jump_instance_ad = data.oci_identity_availability_domains.service_ads.availability_domains[0].name
  jump_instance_hostclass = local.host_class
  service_vcn_cidr = local.service_vcn_cidr
  service_vcn_lpg_id = module.service_network.service_jump_lpg_id
  bastion_lpg_requestor_tenancy_ocid = module.region_config.bastion_lpg_requestor_tenancy_ocid
  bastion_lpg_requestor_group_ocid = module.region_config.bastion_lpg_requestor_group_ocid
}

module "dns" {
  source = "./modules/dns"

  region = local.execution_target.region.public_name
  api_service_public_loadbalancer_ip_address = module.service_lb.api_service_public_loadbalancer_ip_address
}
