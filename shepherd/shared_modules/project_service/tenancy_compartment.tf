locals {
  project_svc_tenancy_ocid_map = {
    "beta" = "ocid1.tenancy.oc1..aaaaaaaahsav5slbvffyyakyjy7ei3g75wlyg65zbahrmn2hrkrc6rrhqqxa" //dlcproject

    "preprod" = "ocid1.tenancy.oc1..aaaaaaaaxk63qg5pdoarb5ujeciq2rqjun6n23tszzwofrqaq7thiaoz7eja" //devopsprojectpre

    "prod" = "ocid1.tenancy.oc1..aaaaaaaaiw6ql6qiyfaed2ug3escrjar5azwwkf73efwmwpr4jryirourifq" //devopsproject
  }

  project_svc_cp_compartment_name = "project_service_control_plane_api"

  project_svc_tenancy_id = lookup(local.project_svc_tenancy_ocid_map, var.environment, "not_defined")

  project_svc_cp_compartment_id = [for c in data.oci_identity_compartments.all_compartments.compartments : c if c.name == local.project_svc_cp_compartment_name][0].id

}

data "oci_identity_compartments" "all_compartments" {
  compartment_id = local.project_svc_tenancy_id
}

output "project_svc_cp_tenancy_id" {
  value = local.project_svc_tenancy_id
}

output "project_svc_cp_compartment_id" {
  value = local.project_svc_cp_compartment_id
}

