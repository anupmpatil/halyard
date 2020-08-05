// https://confluence.oci.oraclecorp.com/pages/viewpage.action?spaceKey=OCICSO&title=Griffin+Agent+GA+Deployment+Instructions
variable "griffin_tenancy_map" {
  type = map(string)

  default = {
    r1  = "ocid1.tenancy.region1..aaaaaaaaggynodpalm5u6ish7ky54xcj4z2c6gzwgmvvudheq53i35fnhdpq"
    oc1 = "ocid1.tenancy.oc1..aaaaaaaafi4l6qecddifs7kew5uzc24xwvtraosoiyvjgc5rq26nciigrhtq"
    oc4 = "ocid1.tenancy.oc4..aaaaaaaaxqh7aigjuf5btznb2ggudiradomo5jzm4xfc6fpr4gfztqdoq6iq"
    oc8 = "ocid1.tenancy.oc8..aaaaaaaa5kx27krp7wk6ubpxkepw4tvebkbphcomgu2ncyqhsf76shznkwrq"
  }
}

output "griffin_tenancy_ocid" {
  value = var.griffin_tenancy_map[var.realm]
}