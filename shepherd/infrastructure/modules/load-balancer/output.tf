output "service_lb_id" {
  value = oci_load_balancer_load_balancer.service_public_loadbalancer.id
}

output "service_lb_backend_set_name" {
  value = local.service_backend_set_name
}

output "api_service_public_loadbalancer_ip_address" {
  value = oci_load_balancer_load_balancer.service_public_loadbalancer.ip_address_details[0].ip_address
}