locals {
  deployment_service_public_endpoint_domain_map = {
    "beta"    = "oci.oc-test.com"
    "preprod" = "oci.oc-test.com"
    "oc1"     = "oci.oraclecloud.com"
    "oc2"     = "oci.oraclegovcloud.com"
    "oc3"     = "oci.oraclegovcloud.com"
    "oc4"     = "oci.oraclegovcloud.uk"
    "oc5"     = "oci.oraclecloud5.com"
    "oc6"     = "oci.oc.scloud"
    "oc7"     = "oci.oc.ic.gov"
    "oc8"     = "oci.oraclecloud8.com"
  }

  deployment_service_internal_endpoint_domain_map = {
    "beta"    = "oci.oc-test.com"
    "preprod" = "oci.oc-test.com"
    "oc1"     = "oci.oracleiaas.com"
    "oc2"     = "oci.oraclegoviaas.com"
    "oc3"     = "oci.oraclegoviaas.com"
    "oc4"     = "oci.oraclegoviaas.uk"
    "oc5"     = "oci.oraclerealm5.com"
    "oc6"     = "oci.oci.scloud"
    "oc7"     = "oci.oci.ic.gov"
    "oc8"     = "oci.oraclerealm8.com"
  }

  oci_service_public_endpoint_domain_map = {
    "beta"    = "oraclecloud.com"
    "preprod" = "oraclecloud.com"
    "oc1"     = "oraclecloud.com"
    "oc2"     = "oraclegovcloud.com"
    "oc3"     = "oraclegovcloud.com"
    "oc4"     = "oraclegovcloud.uk"
    "oc5"     = "oraclecloud5.com"
    "oc6"     = "oc.scloud"
    "oc7"     = "oc.ic.gov"
    "oc8"     = "oraclecloud8.com"
  }

  oci_service_internal_endpoint_domain_map = {
    "beta"    = "oracleiaas.com"
    "preprod" = "oracleiaas.com"
    "oc1"     = "oracleiaas.com"
    "oc2"     = "oraclegoviaas.com"
    "oc3"     = "oraclegoviaas.com"
    "oc4"     = "oraclegoviaas.uk"
    "oc5"     = "oraclerealm5.com"
    "oc6"     = "oci.scloud"
    "oc7"     = "oci.ic.gov"
    "oc8"     = "oraclerealm8.com"
  }

  oci_service_public_endpoint_domain_new_map = {
    "beta"    = join(".", ["oci", local.oci_service_public_endpoint_domain_map["beta"]])
    "preprod" = join(".", ["oci", local.oci_service_public_endpoint_domain_map["preprod"]])
    "oc1"     = join(".", ["oci", local.oci_service_public_endpoint_domain_map["oc1"]])
    "oc2"     = join(".", ["oci", local.oci_service_public_endpoint_domain_map["oc2"]])
    "oc3"     = join(".", ["oci", local.oci_service_public_endpoint_domain_map["oc3"]])
    "oc4"     = join(".", ["oci", local.oci_service_public_endpoint_domain_map["oc4"]])
    "oc5"     = join(".", ["oci", local.oci_service_public_endpoint_domain_map["oc5"]])
    "oc6"     = join(".", ["oci", local.oci_service_public_endpoint_domain_map["oc6"]])
    "oc7"     = join(".", ["oci", local.oci_service_public_endpoint_domain_map["oc7"]])
    "oc8"     = join(".", ["oci", local.oci_service_public_endpoint_domain_map["oc8"]])
  }

  oci_service_internal_endpoint_domain_new_map = {
    "beta"    = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["beta"]])
    "preprod" = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["preprod"]])
    "oc1"     = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["oc1"]])
    "oc2"     = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["oc2"]])
    "oc3"     = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["oc3"]])
    "oc4"     = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["oc4"]])
    "oc5"     = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["oc5"]])
    "oc6"     = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["oc6"]])
    "oc7"     = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["oc7"]])
    "oc8"     = join(".", ["oci", local.oci_service_internal_endpoint_domain_map["oc8"]])
  }

}

locals {
  lookup_key = var.environment == "prod" ? var.realm : var.environment
}

output "deployment_service_public_endpoint_domain" {
  value = local.deployment_service_public_endpoint_domain_map[local.lookup_key]
}

output "deployment_service_internal_endpoint_domain" {
  value = local.deployment_service_internal_endpoint_domain_map[local.lookup_key]
}

output "oci_service_public_endpoint_domain" {
  value = local.oci_service_public_endpoint_domain_map[local.lookup_key]
}

output "oci_service_internal_endpoint_domain" {
  value = local.oci_service_internal_endpoint_domain_map[local.lookup_key]
}

output "oci_service_public_endpoint_domain_new" {
  value = local.oci_service_public_endpoint_domain_new_map[local.lookup_key]
}

output "oci_service_internal_endpoint_domain_new" {
  value = local.oci_service_internal_endpoint_domain_new_map[local.lookup_key]
}

