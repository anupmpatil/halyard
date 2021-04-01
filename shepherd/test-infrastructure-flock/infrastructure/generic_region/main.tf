locals {
  integration_test_compartment_id = module.identity.integration_test_compartment.id
  service_availability_domains    = [for ad in local.availability_domains : ad.name]
  service_vcn_cidr                = "10.0.0.0/16"
  k8s_cluster_version             = "v1.18.10"
}

module "image_type" {
  source = "./shared_modules/image"
  realm  = local.execution_target.region.realm
  region = local.execution_target.region.public_name
}

module "image" {
  source         = "./modules/image"
  compartment_id = local.integration_test_compartment_id
  image_type     = module.image_type.image_type
}

module "identity" {
  source                        = "./shared_modules/identity"
  canary_tenancy_ocid           = lookup(module.tenancies.canary_test_tenancy_ocid_map, local.execution_target.phase_name, "not_defined")
  tenancy_ocid                  = local.execution_target.tenancy_ocid
  integration_test_tenancy_ocid = lookup(module.tenancies.integ_test_tenancy_ocid_map, local.execution_target.phase_name, "not_defined")
}

module "tenancies" {
  source = "./shared_modules/common_files"
}

module "network_setup_integration_test" {
  source           = "./modules/network"
  region           = local.execution_target.region
  compartment_id   = local.integration_test_compartment_id
  service_vcn_cidr = local.service_vcn_cidr
  service_name     = "test-tenancy-network-infra"
  dns_label        = "testnet"
}

module "instance_group_integration_test" {
  source                                = "./modules/instances"
  region                                = local.execution_target.region.public_name
  tenancy_ocid                          = local.execution_target.tenancy_ocid
  compartment_id                        = local.integration_test_compartment_id
  service_instance_shape                = "VM.Standard2.1"
  service_instance_name_prefix          = "instance-group-deployment-test"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = "instance-group-deployment-test-instances"
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.network_setup_integration_test.test_public_subnet_id
}

module "oke_cluster_integration_test" {
  source               = "./modules/oke-cluster"
  compartment_id       = local.integration_test_compartment_id
  vcn_id               = module.network_setup_integration_test.test_vcn_id
  k8s_cluster_version  = local.k8s_cluster_version
  availability_domains = local.service_availability_domains
  k8s_worker_subnet_id = module.network_setup_integration_test.test_private_subnet_id
  node_image_id        = module.image.overlay_image.id
  tenancy_ocid         = local.execution_target.tenancy_ocid
  lb_public_subnet     = module.network_setup.test_public_subnet_id
}

module "functions_integration_test" {
  compartment_id           = local.integration_test_compartment_id
  application_subnet_ids   = module.network_setup_integration_test.test_public_subnet_id
  application_display_name = "Integration_test_func_application"
  function_display_name    = "Integration_test_func"
  function_memory_in_mbs   = 128
  function_image           = ""
}