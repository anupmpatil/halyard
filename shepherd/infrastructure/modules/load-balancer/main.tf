locals {
  service_backend_set_name = "service_backend_set"
}

// Create load balancer
resource "oci_load_balancer_load_balancer" "service_public_loadbalancer" {
  compartment_id = var.compartment_id
  display_name = var.display_name
  shape = var.lb_shape
  subnet_ids = [var.subnet_id]
  is_private = false
}

// Create load balancer listener. By default configure the LB as TCP LB.
resource "oci_load_balancer_listener" "service_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.service_backend_set.name
  load_balancer_id = oci_load_balancer_load_balancer.service_public_loadbalancer.id
  name = "lb_listener_${oci_load_balancer_load_balancer.service_public_loadbalancer.display_name}"
  port = var.listener_port
  protocol = "TCP"
}

// Create the default backend set. Backends(hosts) will be added right after they're created.
resource "oci_load_balancer_backend_set" "service_backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.service_public_loadbalancer.id
  name = local.service_backend_set_name
  policy = "ROUND_ROBIN"

  // Probably not a good idea to use TCP healthcheck in production, this is just a basic work out-of-box solution.
  // Please update to either HTTP or HTTPS(when supported) when your hosts are ready.
  health_checker {
    protocol = "TCP"
    interval_ms = 15000 //15 seconds
    port = var.host_listening_port
    retries = 3
    timeout_in_millis = 5000
  }
}
