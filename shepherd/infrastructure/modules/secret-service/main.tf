// We are using secret service V2 to manage our secrets.
// Link to SSV2 -https://confluence.oci.oraclecorp.com/display/OCIID/Secret+Service+v2+Overview
locals {
  tls_certificate_name = "tls.certificate"
  tls_intermediate_name = "tls.intermediate"
  tls_privateKey_name = "tls.privateKey"
}

// Namespace of the secrets.
resource "sms_namespace" "namespace" {
  name = var.name_space
  description = var.name_space
  ticket_queue = var.team_queue

  compartment_id = var.compartment_id
}

// Secrets access.
resource "sms_access" "service_access" {
  name = "DefaultAccess"
  description = "Default Access for ${var.name_space}"
  entity_ocid = sms_namespace.namespace.id

  resource_ocid = var.compartment_id
}

// TLS Certificate.
resource "sms_secret_definition" "tls_certificate" {
  name = local.tls_certificate_name
  description = "TLS Certificate"
  path = "tls/cert"
  service_ocid = sms_namespace.namespace.id
}

// TLS Intermediate Cert.
resource "sms_secret_definition" "tls_intermediate" {
  name = local.tls_intermediate_name
  description = "TLS Intermediate Cert"
  path = "tls/intermediate"
  service_ocid = sms_namespace.namespace.id
}

// TLS Private Key.
resource "sms_secret_definition" "tls_private_key" {
  name = local.tls_privateKey_name
  description = "TLS Private Key"
  path = "tls/key"
  service_ocid = sms_namespace.namespace.id
}
