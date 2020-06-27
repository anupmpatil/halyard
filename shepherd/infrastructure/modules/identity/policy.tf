resource "oci_identity_policy" "boat_access_policy" {
  compartment_id = var.tenancy_ocid
  description    = "BOAT Access Policy"
  name           = "boat_access_policy"
  statements = [
    "define tenancy boat as ${var.boat_tenancy_ocid}",
    "define group dlcdep-sys-admins as ${var.dlcdep_sys_admins_ocid}",
    "admit group dlcdep-sys-admins of tenancy boat to manage all-resources in tenancy"
  ]
}
resource "oci_identity_policy" "image-tags-namespace-policy" {
  compartment_id = var.tenancy_ocid
  description    = "Allow Compute service to tag namespace in tenancy"
  name           = "dlc-image-tag-namespace"
  statements     = ["allow service compute_management to use tag-namespace in tenancy"]
}

resource "oci_identity_policy" "odo_policy" {
  compartment_id = var.tenancy_ocid
  description    = "This policy allows group to make read requests to the ODO artifact bucket for that tenancy"
  name           = "dlc-odo-policy"
  statements = [
    "define tenancy ODO as ${var.odo_tenancy_ocid}",
    "endorse dynamic-group ${oci_identity_dynamic_group.odo_dynamic_group.name} to read object-family in tenancy ODO",
  ]
}

resource "oci_identity_policy" "access-managers" {
  compartment_id = var.tenancy_ocid
  name           = "access-managers"
  description    = "Host updater policy for dynamic group ${oci_identity_dynamic_group.access_managers_dynamic_group.name}"

  statements = [
    "define tenancy secinf as ${var.secinf_tenancy_ocid}",
    "endorse dynamic-group ${oci_identity_dynamic_group.access_managers_dynamic_group.name} to read object-family in tenancy secinf",
  ]
}

resource "oci_identity_policy" "security_central_policy" {
  compartment_id = var.tenancy_ocid
  description    = "This policy allows group to perform defined set of operations in security central"
  name           = "security-central-policy"
  statements = [
    "define tenancy boat as ${var.boat_tenancy_ocid}",
    "define group dlcdep-sys-admins as ${var.dlcdep_sys_admins_ocid}",
    "admit group dlcdep-sys-admins of tenancy boat to {SECURITYCENTRAL_TASK_READ, SECURITYCENTRAL_FINDING_READ, SECURITYCENTRAL_TEAM_CREATE, SECURITYCENTRAL_TEAM_READ, SECURITYCENTRAL_TEAM_UPDATE} in tenancy",
  ]
}

resource "oci_identity_policy" "secret_service_policy" {
  compartment_id = var.tenancy_ocid
  description    = "This policy allows CertNanny serivce to update secret versions"
  name           = "dlc-ss-policy"
  statements = [
    "ALLOW service CertNanny TO {SECRET-SERVICE-MANAGE-SECRET-VERSION} IN COMPARTMENT ${oci_identity_compartment.deployment_service_control_plane_api.name}"
  ]
}

resource "oci_identity_policy" "telemetry_policy" {
  compartment_id = var.tenancy_ocid
  description    = "Overlay Telemetry T2 for dynamic group ${oci_identity_dynamic_group.access_managers_dynamic_group.name}"
  name           = "telemetry_policy"
  statements = [
    "define tenancy telemetry as ${var.telemetry_tenancy_ocid}",
    "endorse dynamic-group ${oci_identity_dynamic_group.access_managers_dynamic_group.name} to use metrics in tenancy telemetry"
  ]
}

resource "oci_identity_policy" "limits_policy" {
  compartment_id = var.tenancy_ocid
  description    = "This policy allows group to manage WRITE operations within the Limits Service"
  name           = "limits_policy"
  statements = [
    "define tenancy boat as ${var.boat_tenancy_ocid}",
    "define group limits-dlcdep-admins as ${var.limits_group_ocid}",
    "admit group limits-dlcdep-admins of tenancy boat to manage LIMITS in compartment ${oci_identity_compartment.deployment_limits.name}"
  ]
}

resource "oci_identity_policy" "splat_policy" {
  compartment_id = var.tenancy_ocid
  description    = "This policy allows group to manage certain operations in Splat"
  name           = "splat_policy"
  statements = [
    "define tenancy boat as ${var.boat_tenancy_ocid}",
    "define group dlcdep-sys-admins as ${var.dlcdep_sys_admins_ocid}",
    "admit group dlcdep-sys-admins of tenancy boat to manage operational-specs in compartment ${oci_identity_compartment.deployment_splat.name}",
    "admit group dlcdep-sys-admins of tenancy boat to manage partner-services in compartment ${oci_identity_compartment.deployment_splat.name}",
    "admit group dlcdep-sys-admins of tenancy boat to manage partner-service-specs in compartment ${oci_identity_compartment.deployment_splat.name}",
    "admit group dlcdep-sys-admins of tenancy boat to manage partner-service-spec-deployments in compartment ${oci_identity_compartment.deployment_splat.name}"
  ]
}