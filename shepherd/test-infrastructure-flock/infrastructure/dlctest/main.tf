locals {
  compartment_id_map = {
    "dlctest_test_resources" = "ocid1.compartment.oc1..aaaaaaaay5gb3fgvz7jmftxetks7r7mbusqhylw6hsbzkkthzwwsymmhu4ha"
  }
  service_availability_domains = [for ad in local.availability_domains : ad.name]
  service_vcn_cidr             = "10.0.0.0/16"
  k8s_cluster_version          = "v1.18.10"
}

module "image" {
  source         = "./modules/image"
  compartment_id = local.compartment_id_map["dlctest_test_resources"]
}

module "network_setup" {
  source           = "./modules/network"
  region           = local.execution_target.region
  compartment_id   = local.compartment_id_map["dlctest_test_resources"]
  service_vcn_cidr = local.service_vcn_cidr
  service_name     = "test-tenancy-network-infra"
  dns_label        = "testnet"
}

module "insance_group_deployment_instances" {
  source                                = "./modules/instances"
  region                                = local.execution_target.region.public_name
  tenancy_ocid                          = local.execution_target.tenancy_ocid
  compartment_id                        = local.compartment_id_map["dlctest_test_resources"]
  service_instance_shape                = "VM.Standard2.1"
  service_instance_name_prefix          = "instance-group-deployment-test"
  service_instance_image_id             = module.image.overlay_image.id
  service_instances_hostclass_name      = "instance-group-deployment-test-instances"
  service_instance_availability_domains = local.service_availability_domains
  instance_count_per_ad                 = 1
  service_subnet_id                     = module.network_setup.ig_test_subnet_id
}

module "oke_cluster_deployment" {
  source               = "./modules/oke-cluster"
  compartment_id       = local.compartment_id_map["dlctest_test_resources"]
  vcn_id               = module.network_setup.ig_test_vcn_id
  k8s_cluster_version  = local.k8s_cluster_version
  availability_domains = local.service_availability_domains
  k8s_worker_subnet_id = module.network_setup.ig_test_subnet_id
  node_image_id        = module.image.overlay_image.id
  tenancy_ocid         = local.execution_target.tenancy_ocid
  //k8s_worker_subnet_id = module.network_setup.ig_test_subnet_id
  //k8s_worker_subnet_id = module.network_setup.node_pool_test_subnet_id
}