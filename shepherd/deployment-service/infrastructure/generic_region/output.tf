output "control_plane_api_application" {
  value       = module.odo_application_control_plane.odo_application_api
  description = "Control plane API ODO App"
}

output "control_plane_worker_application" {
  value       = module.odo_application_control_plane.odo_application_worker
  description = "Control worker API ODO App"
}

output "control_plane_os_updater_application" {
  value       = module.odo_application_control_plane.os_updater
  description = "Control plane Os Updater ODO App"
}

output "management_plane_api_application" {
  value       = module.odo_application_management_plane.odo_application_api
  description = "Management plane API ODO App"
}

output "data_plane_worker_application" {
  value       = module.odo_application_management_plane.odo_application_worker
  description = "Data plane API ODO App"
}

output "management_plane_os_updater_application" {
  value       = module.odo_application_management_plane.os_updater
  description = "Management plane Os Updater ODO App"
}

output "availability_domains" {
  value       = local.service_availability_domains
  description = "List of availability domains where resources are created."
}

output "bastion_os_updater_application" {
  value       = module.ob3_jump.os_updater_bastion
  description = "Bastion Os Updater ODO App"
}

output "secedge_data_jump_vcn_cidr" {
  value = local.ob3_jump_vcn_cidr
}

output "secedge_data_vcn" {
  value = module.bastion_config.ob3_jump_vcn
}

output "secedge_data_jump_vcn_lpg_ocid" {
  value = module.ob3_jump.ob3_jump_vcn_lpt
}

