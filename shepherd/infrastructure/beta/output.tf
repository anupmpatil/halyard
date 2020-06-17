output "api_instance_pools" {
  value = module.service_instances_api.created_instance_pool
  description = "OCID of the created API instance pools in each AD."
}

output "worker_instance_pools" {
  value = module.service_instances_worker.created_instance_pool
  description = "OCID of the created Worker instance pool in each AD."
}

output "api_compartment_id" {
  value = local.api_compartment_id
  description = "The compartment id for the API service."
}

output "worker_compartment_id" {
  value = local.api_compartment_id
  description = "The compartment id for the Worker service."
}

output "availability_domains" {
  value = local.service_availability_domains
  description = "List of availability domains where resources are created."
}

output "service_subnet_id" {
  value = module.service_network.service_subnet_id
  description = "OCID of the service's subnet."
}

output "api_fleet_name" {
  value = local.api_fleet_name
}

output "worker_fleet_name" {
  value = local.worker_fleet_name
}

output "kaas_endpoint" {
  value = module.kiev.kiev_endpoint
  description = "Regional kiev instance endpoint."
}
