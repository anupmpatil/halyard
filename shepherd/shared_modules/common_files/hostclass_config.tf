locals {
  oci_host_classes_prod_map = {
    dep-service-cp-api    = "DEPLOYMENT-SERVICE-CP-API"
    dep-service-mgt-api   = "DEPLOYMENT-SERVICE-MGT-API"
    dep-service-cp-worker = "DEPLOYMENT-SERVICE-CP-WORKER"
    dep-service-dp-worker = "DEPLOYMENT-SERVICE-DP-WORKER"
    dep-service-bastion   = "deployment-service-bastions"
  }

  oci_host_classes_dev_map = {
    dep-service-cp-api    = "DEPLOYMENT-SERVICE-CP-API-DEV"
    dep-service-mgt-api   = "DEPLOYMENT-SERVICE-MGT-API-DEV"
    dep-service-cp-worker = "DEPLOYMENT-SERVICE-CP-WRKR-DEV"
    dep-service-dp-worker = "DEPLOYMENT-SERVICE-DP-WRKR-DEV"
    dep-service-bastion   = "deployment-service-bastions-dev"
  }
}

output "oci_host_classes_prod_map" {
  value = local.oci_host_classes_prod_map
}

output "oci_host_classes_dev_map" {
  value = local.oci_host_classes_dev_map
}

