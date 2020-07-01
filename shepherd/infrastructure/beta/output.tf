output "control_plane_api_instance_pools" {
  value       = module.service_instances_control_plane_api.instance_pools
  description = "OCID of the control plane api instance pools in each AD."
}

output "control_plane_worker_instance_pools" {
  value       = module.service_instances_control_plane_worker.instance_pools
  description = "OCID of the control plane worker instance pools in each AD."
}

output "management_plane_api_instance_pools" {
  value       = module.service_instances_management_plane_api.instance_pools
  description = "OCID of the management plane api instance pools in each AD."
}

output "data_plane_worker_instance_pools" {
  value       = module.service_instances_data_plane_worker.instance_pools
  description = "OCID of the data plane worker instance pools in each AD."
}

output "availability_domains" {
  value       = local.service_availability_domains
  description = "List of availability domains where resources are created."
}