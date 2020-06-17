output "sms_namespace" {
  value = sms_namespace.namespace
  description = "The namespace that the secrets are hosted in."
}

output "tls_certificate" {
  value = sms_secret_definition.tls_certificate
  description = "The tls certificate for the api service."
}