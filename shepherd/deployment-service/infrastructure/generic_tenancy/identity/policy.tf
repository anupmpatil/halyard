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
    "ALLOW service CertNanny TO {SECRET-SERVICE-MANAGE-SECRET-VERSION} IN COMPARTMENT ${oci_identity_compartment.deployment_service_control_plane_api.name}",
    "ALLOW service CertNanny TO {SECRET-SERVICE-MANAGE-SECRET-VERSION} IN COMPARTMENT ${oci_identity_compartment.deployment_service_management_plane_api.name}"
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

resource "oci_identity_policy" "lumberjack-policies" {
  #Required
  compartment_id = var.tenancy_ocid
  description    = "Lumberjack onboarding policies"
  name           = "lumberjack-policies"
  statements = [
    "allow service ${var.service_principal_name} to {AUDIT_DEFINITION_READ, AUDIT_READ, AUDIT_WRITE, AUDIT_DEFINITION_WRITE, AUDIT_CONFIGURATION_READ} in tenancy",
    "allow service ${var.service_principal_name} to use logs in tenancy",
    "allow dynamic-group ${oci_identity_dynamic_group.access_managers_dynamic_group.name} to use logs in tenancy"
  ]
}

resource "oci_identity_policy" "tim-service-allow" {
  compartment_id = var.tenancy_ocid
  description    = "Allows tim-service to read all-resources in this tenancy."
  name           = "tim-service-allow"
  statements = [
    "allow service tim-service to read all-resources in tenancy",
  ]
}

resource "oci_identity_policy" "griffin-agent-policies" {
  #Required
  compartment_id = var.tenancy_ocid
  description    = "Hippogriff policy to allow write to the MVP log target from the tenancy"
  name           = "Hippogriff-policies"
  statements = [
    "define tenancy security-log as ${var.griffin_agent_tenancy_ocid}",
    "endorse any-user to {LOG_WRITE, LOG_DEFINITION_READ, LOG_DEFINITION_WRITE, LOG_NAMESPACE_READ, UNIFIEDAGENT_CONFIG_GENERATE} in tenancy security-log"
  ]
}

resource "oci_identity_policy" "wfaas-policies" {
  compartment_id = var.tenancy_ocid
  description    = "wfaas policies to allow workflow service"
  name           = "wfaas-policies"
  statements = [
    "define tenancy boat as ${var.boat_tenancy_ocid}",
    "define group dlcdep-sys-admins as ${var.dlcdep_sys_admins_ocid}",
    "allow dynamic-group ${oci_identity_dynamic_group.deployment_worker_service_dynamic_group.name} to manage workflow-family in compartment ${oci_identity_compartment.deployment_service_control_plane_worker.name}",
    "allow dynamic-group ${oci_identity_dynamic_group.deployment_worker_service_dynamic_group.name} to manage workflow-family in compartment ${oci_identity_compartment.deployment_service_data_plane_worker.name}"
  ]
}

resource "oci_identity_policy" "bastion_policy" {
  // This ocid is for the root compartment where the policy resides
  compartment_id = var.tenancy_ocid

  description = "bastion lpg for compartment ${var.bastion_compartment_id}"
  name        = "bastion-lpg-policy"

  statements = [
    "define tenancy Requestor as ${var.bastion_lpg_requestor_tenancy_ocid}",
    "define group RequestorGrp as ${var.bastion_lpg_requestor_group_ocid}",
    "admit group RequestorGrp of tenancy Requestor to manage local-peering-to in compartment id ${var.bastion_compartment_id}",
    "admit group RequestorGrp of tenancy Requestor to associate local-peering-gateways in tenancy Requestor with local-peering-gateways in compartment id ${var.bastion_compartment_id}"
  ]
}

resource "oci_identity_policy" "cd_rqs_policy" {
  count          = var.enable_create_tenancy_policies == "true" ? 1 : 0
  name           = "DevOpsDeployRQSPolicy"
  description    = "DevOps Deploy RQS Policy"
  compartment_id = var.tenancy_ocid
  statements = [
    # Below policy statements are needed to allow splat to manage RQS on our behalf.
    # The RQS schemas must be owned by service tenancy (PRODUCTION) compartments.
    "ALLOW SERVICE splat TO {RQS_RESOURCE_MANAGE} IN COMPARTMENT ${
    var.deployment_service_control_plane_api_compartment_name} WHERE all {event.resource.scope = 'CUSTOMER', event.resource.type = 'DevOpsDeployPipeline'}",
    "ALLOW SERVICE splat TO {RQS_RESOURCE_MANAGE} IN COMPARTMENT ${
    var.deployment_service_control_plane_api_compartment_name} WHERE all {event.resource.scope = 'CUSTOMER', event.resource.type = 'DevOpsDeployStage'}",
    "ALLOW SERVICE splat TO {RQS_RESOURCE_MANAGE} IN COMPARTMENT ${
    var.deployment_service_control_plane_api_compartment_name} WHERE all {event.resource.scope = 'CUSTOMER', event.resource.type = 'DevOpsDeployArtifact'}",
    "ALLOW SERVICE splat TO {RQS_RESOURCE_MANAGE} IN COMPARTMENT ${
    var.deployment_service_control_plane_api_compartment_name} WHERE all {event.resource.scope = 'CUSTOMER', event.resource.type = 'DevOpsDeployEnvironment'}",
    "ALLOW SERVICE splat TO {RQS_RESOURCE_MANAGE} IN COMPARTMENT ${
    var.deployment_service_management_plane_api_compartment_name} WHERE all {event.resource.scope = 'CUSTOMER', event.resource.type = 'DevOpsDeployment'}"
  ]
}

resource "oci_identity_policy" "cross_tenancy_kiev_policy" {
  compartment_id = var.tenancy_ocid
  description    = "Policy to endorse our tenancy to access kaas store owned by ProjectService"
  name           = "cross-tenancy-kiev-policy"
  statements = [
    "Define tenancy projectTenancy as ${var.project_tenancy_ocid}",
    "Endorse dynamic-group odo-dynamic-group to manage kiev-data-stores in tenancy projectTenancy"
  ]
}
