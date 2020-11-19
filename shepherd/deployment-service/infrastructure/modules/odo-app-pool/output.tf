output "odo_application_api" {
  value       = odo_application.odo_application_api
  description = "ODO API Application"
}

output "odo_application_worker" {
  value       = odo_application.odo_application_worker
  description = "ODO Worker Application"
}

output "os_updater" {
  value       = odo_application.os_updater
  description = "ODO OS_Updater Application"
}