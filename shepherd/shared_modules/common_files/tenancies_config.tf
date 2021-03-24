locals {
  tenancy_ocid_map = {
    "beta"    = "ocid1.tenancy.oc1..aaaaaaaazcj7jjwnom4hyjvzdxdsyomxbeaao3v7keizrtllhc5g2r35hyca"
    "preprod" = "ocid1.tenancy.oc1..aaaaaaaakiqb4agx7mu4hqu7rtitlmirgsv3z3nth4qasokxnzvqbp2dgoza"
    "oc1"     = "ocid1.tenancy.oc1..aaaaaaaatvulfxx72mqjtzkj75wtgvcvqac6lo7lwll2yvl7rjqwnvicbs7q"
  }

  tenancy_name_map = {
    "beta"    = "devopsdeploydev"
    "preprod" = "devopsdeploypreprod"
    "oc1"     = "devopsdeployprod"
  }

  canary_test_tenancy_ocid_map = {
    "beta"       = "ocid1.tenancy.oc1..aaaaaaaavhpcp5czywf2djkxv3mcswbdobuvpwk24mbcll72tkuskw7qhw5q" /* dlctest tenancy (will update once Raj update the tenancy) */
    "preprod"    = "ocid1.tenancy.oc1..aaaaaaaaes5ujidrlz2t2ry56rltbi5jxifr7eresraa2ukbygfw6aocd7aq" /* devopsdeploypreprodcanary tenancy */
    "oc1-groupA" = "ocid1.tenancy.oc1..aaaaaaaaovj5jeahe56kfhof4b2gmnwkqc6wfz5hnkkvesafzmeh5g3pppda" /* deploymentservicecanary tenancy */
    "oc1-groupB" = "ocid1.tenancy.oc1..aaaaaaaaovj5jeahe56kfhof4b2gmnwkqc6wfz5hnkkvesafzmeh5g3pppda" /* deploymentservicecanary tenancy */
    "oc1-groupC" = "ocid1.tenancy.oc1..aaaaaaaaovj5jeahe56kfhof4b2gmnwkqc6wfz5hnkkvesafzmeh5g3pppda" /* deploymentservicecanary tenancy */
    "oc1-groupD" = "ocid1.tenancy.oc1..aaaaaaaaovj5jeahe56kfhof4b2gmnwkqc6wfz5hnkkvesafzmeh5g3pppda" /* deployment servicecanary tenancy */
  }

  integ_test_tenancy_ocid_map = {
    "beta"       = "ocid1.tenancy.oc1..aaaaaaaavhpcp5czywf2djkxv3mcswbdobuvpwk24mbcll72tkuskw7qhw5q" /* dlctest tenancy (will update once Raj update the tenancy) */
    "preprod"    = "ocid1.tenancy.oc1..aaaaaaaa7rtxdhu6g5ytlkbtrl74vfkbtygcahfgdrzqsrum3fmsqwv336dq" /* devopsdeploypreprodtest tenancy */
    "oc1-groupA" = "ocid1.tenancy.oc1..aaaaaaaaxenqwglrtzhjupenylgkm4hpwepracpqcffbmyk3cqy4slcfz7ba" /* devopsdeployprodtest tenancy */
    "oc1-groupB" = "ocid1.tenancy.oc1..aaaaaaaaxenqwglrtzhjupenylgkm4hpwepracpqcffbmyk3cqy4slcfz7ba" /* devopsdeployprodtest tenancy */
    "oc1-groupC" = "ocid1.tenancy.oc1..aaaaaaaaxenqwglrtzhjupenylgkm4hpwepracpqcffbmyk3cqy4slcfz7ba" /* devopsdeployprodtest tenancy */
    "oc1-groupD" = "ocid1.tenancy.oc1..aaaaaaaaxenqwglrtzhjupenylgkm4hpwepracpqcffbmyk3cqy4slcfz7ba" /* devopsdeployprodtest tenancy */
  }
}

output "tenancy_ocid_map" {
  value = local.tenancy_ocid_map
}

output "tenancy_name_map" {
  value = local.tenancy_name_map
}

output "canary_test_tenancy_ocid_map" {
  value = local.canary_test_tenancy_ocid_map
}

output "integ_test_tenancy_ocid_map" {
  value = local.integ_test_tenancy_ocid_map
}