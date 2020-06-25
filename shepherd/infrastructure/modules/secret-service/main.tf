// We are using secret service V2 to manage our secrets.
// Link to SSV2 -https://confluence.oci.oraclecorp.com/display/OCIID/Secret+Service+v2+Overview
locals {
  tls_bundle_name = "tls.bundle"
}

// Namespace of the secrets.
resource "sms_namespace" "control_plane_api_namespace" {
  name = var.control_plane_api_namespace
  description = var.control_plane_api_namespace
  ticket_queue = var.team_queue
  compartment_id = var.control_plane_api_compartment_id
}

resource "sms_namespace" "management_plane_api_namespace" {
  name = var.management_plane_api_namespace
  description = var.management_plane_api_namespace
  ticket_queue = var.team_queue
  compartment_id = var.management_plane_api_compartment_id
}

// Secrets access.
resource "sms_access" "control_plane_api_service_access" {
  name = "DefaultAccess"
  description = "Default Access for ${var.control_plane_api_namespace}"
  entity_ocid = sms_namespace.control_plane_api_namespace.id
  resource_ocid = var.control_plane_api_compartment_id
}

resource "sms_access" "management_plane_api_service_access" {
  name = "DefaultAccess"
  description = "Default Access for ${var.management_plane_api_namespace}"
  entity_ocid = sms_namespace.management_plane_api_namespace.id
  resource_ocid = var.management_plane_api_compartment_id
}

// TLS bundle.
resource "sms_secret_definition" "tls_bundle_control_plane_api" {
  name = local.tls_bundle_name
  description = "TLS bundle"
  path = "tls/bundle"
  service_ocid = sms_namespace.control_plane_api_namespace.id
}

resource "sms_secret_definition" "tls_bundle_management_plane_api" {
  name = local.tls_bundle_name
  description = "TLS bundle"
  path = "tls/bundle"
  service_ocid = sms_namespace.management_plane_api_namespace.id
}
