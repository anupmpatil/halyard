// We are using secret service V2 to manage our secrets.
// Link to SSV2 -https://confluence.oci.oraclecorp.com/display/OCIID/Secret+Service+v2+Overview
locals {
  tls_bundle_name = "tls.bundle"
}

data "certificate_data_source" "tls_server_cert_deployment_service_management_plane_api" {
  compartment_id   = var.management_plane_api_compartment_id
  certificate_name = "deployment_service_management_plane_api_tls_server_cert"
}

// Namespace of the secrets.
resource "sms_namespace" "control_plane_api_namespace" {
  name           = var.control_plane_api_namespace
  description    = var.control_plane_api_namespace
  ticket_queue   = var.team_queue
  compartment_id = var.control_plane_api_compartment_id
}

resource "sms_namespace" "management_plane_api_namespace" {
  name           = var.management_plane_api_namespace
  description    = var.management_plane_api_namespace
  ticket_queue   = var.team_queue
  compartment_id = var.management_plane_api_compartment_id
}

// Secrets access.
resource "sms_access" "control_plane_api_service_access" {
  name          = "DefaultAccess"
  description   = "Default Access for ${var.control_plane_api_namespace}"
  entity_ocid   = sms_namespace.control_plane_api_namespace.id
  resource_ocid = var.control_plane_api_compartment_id
}

resource "sms_access" "management_plane_api_service_access" {
  name          = "DefaultAccess"
  description   = "Default Access for ${var.management_plane_api_namespace}"
  entity_ocid   = sms_namespace.management_plane_api_namespace.id
  resource_ocid = var.management_plane_api_compartment_id
}

// TLS bundle.
resource "sms_secret_definition" "tls_bundle_control_plane_api" {
  name         = local.tls_bundle_name
  description  = "TLS bundle"
  path         = "tls/bundle"
  service_ocid = sms_namespace.control_plane_api_namespace.id
}

resource "sms_secret_definition" "tls_bundle_management_plane_api" {
  name         = local.tls_bundle_name
  description  = "TLS bundle"
  path         = "tls/bundle"
  service_ocid = sms_namespace.management_plane_api_namespace.id
}

data "certificate_data_source" "tls_server_cert_deployment_service_control_plane_api" {
  compartment_id   = var.control_plane_api_compartment_id
  certificate_name = "deployment_service_control_plane_api_tls_server_cert"
}

# Deliver certs to secret service
resource "certificate_secret_service_binding_resource" dep_service_cp_api_tls_server_cert_binding {
  certificate_ocid              = data.certificate_data_source.tls_server_cert_deployment_service_control_plane_api.certificate_ocid
  secret_definition_ocid        = sms_secret_definition.tls_bundle_control_plane_api.id
  secret_service_compartment_id = var.control_plane_api_compartment_id
  availability_domain           = "ad1"
}

resource "certificate_secret_service_binding_resource" dep_service_mp_api_tls_server_cert_binding {
  certificate_ocid              = data.certificate_data_source.tls_server_cert_deployment_service_management_plane_api.certificate_ocid
  secret_definition_ocid        = sms_secret_definition.tls_bundle_management_plane_api.id
  secret_service_compartment_id = var.management_plane_api_compartment_id
  availability_domain           = "ad1"
}
