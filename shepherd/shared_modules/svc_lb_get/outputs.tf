output "deploy_lb_ocid" {
  description = "ocid of the public load balancer"
  value       = data.oci_load_balancer_load_balancers.public.load_balancers[0].id
}

output "deploy_lb_host" {
  description = "host of the public load balancer"
  value       = split(".", data.oci_load_balancer_load_balancers.public.load_balancers[0].id)[4]
}

output "deploy_lb_ip" {
  description = "ip of the public load balancer"
  value       = data.oci_load_balancer_load_balancers.public.load_balancers[0].ip_address_details[0].ip_address
}