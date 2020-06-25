output "tls_bundle_control_plane_api" {
  value = sms_secret_definition.tls_bundle_control_plane_api
  description = "The tls bundle for the deployment-control-plane-api service."
}

output "tls_bundle_management_plane_api" {
  value = sms_secret_definition.tls_bundle_management_plane_api
  description = "The tls bundle for the deployment-management-plane-api service."
}