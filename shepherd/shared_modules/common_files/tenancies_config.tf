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

  canary_tenancy_ocid_map = {
    /**
     * we are using dlctest tenancy for beta and deploymentservicedev tenancy for pre-prod below. Switch back to canary tenancy for beta and pre-prod when available
     */

    "beta"    = "ocid1.tenancy.oc1..aaaaaaaavhpcp5czywf2djkxv3mcswbdobuvpwk24mbcll72tkuskw7qhw5q" /* dlctest tenancy */
    "preprod" = "ocid1.tenancy.oc1..aaaaaaaakiqb4agx7mu4hqu7rtitlmirgsv3z3nth4qasokxnzvqbp2dgoza" /* deploymentservicedev tenancy */
    "oc1"     = "ocid1.tenancy.oc1..aaaaaaaaovj5jeahe56kfhof4b2gmnwkqc6wfz5hnkkvesafzmeh5g3pppda"
  }
}

output "tenancy_ocid_map" {
  value = local.tenancy_ocid_map
}

output "tenancy_name_map" {
  value = local.tenancy_name_map
}

output "canary_tenancy_ocid_map" {
  value = local.canary_tenancy_ocid_map
}
