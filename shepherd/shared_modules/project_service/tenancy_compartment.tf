locals {
  project_svc_tenancy_name_map = {
    "beta"    = "dlcproject"
    "preprod" = "devopsprojectpre"
    "prod"    = "devopsproject"
  }

  project_svc_cp_compartment_name = "project_service_control_plane_api"

  project_svc_tenancy_id = data.tenancylookup_ocid.project_svc_tenancy.id

  project_svc_cp_compartment_id = data.oci_identity_compartments.project_svc_compartment.compartments[0].id
}

data "tenancylookup_ocid" "project_svc_tenancy" {
  name = lookup(local.project_svc_tenancy_name_map, var.environment, "not_defined")
}

data "oci_identity_compartments" "project_svc_compartment" {
  compartment_id = local.project_svc_tenancy_id
  filter {
    name   = "name"
    values = [local.project_svc_cp_compartment_name]
  }
}

output "project_svc_cp_tenancy_id" {
  value = local.project_svc_tenancy_id
}

output "project_svc_cp_compartment_id" {
  value = local.project_svc_cp_compartment_id
}
