output "service_jump_lpg_id" {
  value       = oci_core_local_peering_gateway.service_jump_lpg.id
  description = "The ID of the LPG connecting service VCN and jump VCN"
}

output "service_lb_subnet_id" {
  value       = oci_core_subnet.lb_subnet.id
  description = "The regional subnet that hosts public load balancer."
}

output "service_subnet_api_id" {
  value       = oci_core_subnet.service_subnet_api.id
  description = "The subnets that host service compute instances."
}

output "service_subnet_worker_id" {
  value       = oci_core_subnet.service_subnet_worker.id
  description = "The subnets that host worker compute instances."
}
