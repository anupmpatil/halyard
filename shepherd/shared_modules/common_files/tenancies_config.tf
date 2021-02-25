locals {
  tenancy_ocid_map = {
    "beta"    = "ocid1.tenancy.oc1..aaaaaaaazcj7jjwnom4hyjvzdxdsyomxbeaao3v7keizrtllhc5g2r35hyca"
    "preprod" = "ocid1.tenancy.oc1..aaaaaaaakiqb4agx7mu4hqu7rtitlmirgsv3z3nth4qasokxnzvqbp2dgoza"
    "oc1"     = "ocid1.tenancy.oc1..aaaaaaaatvulfxx72mqjtzkj75wtgvcvqac6lo7lwll2yvl7rjqwnvicbs7q"
  }

  tenancy_name_map = {
    "beta"    = "deploymentservicedev"
    "preprod" = "deploymentservicepreprod"
    "oc1"     = "deploymentserviceprod"
  }
}

output "tenancy_ocid_map" {
  value = local.tenancy_ocid_map
}

output "tenancy_name_map" {
  value = local.tenancy_name_map
}
