/* Reference: Shepherd Limits Provider: https://confluence.oci.oraclecorp.com/display/SHEP/Limit+Provider */
//resource "limit_group" "limit_group_resource" {
//  compartment_id = var.compartment_ocid
//  name           = "dlcdep"
//}
//
//resource "limit_definition" "num_of_deployments" {
//  depends_on  = [limit_group.limit_group_resource]
//  group       = limit_group.limit_group_resource.name
//  name        = "num_of_deployments"
//  description = "Number of Deployments"
//  default_min = 0
//  default_max = 100
//}