resource "oci_containerengine_cluster" "test-oke-cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_cluster_version
  name               = var.cluster_name
  vcn_id             = var.oke_cluster.vcn_id

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = var.oke_cluster.cluster_options_kubernetes_network_config_pods_cidr
      services_cidr = var.oke_cluster.cluster_options_kubernetes_network_config_services_cidr
    }
    service_lb_subnet_ids = var.lb_public_subnet
  }
}

data "oci_identity_availability_domains" "availability_domains" {
  #Required
  compartment_id = var.tenancy_ocid
}

resource "oci_containerengine_node_pool" "oke-node_pool1" {
  #Required
  cluster_id         = oci_containerengine_cluster.test-oke-cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_cluster_version
  name               = "node pool for oke cluster"
  node_shape         = "VM.Standard1.1"
  //node_image_id      = var.node_image_id

  node_config_details{
        placement_configs{
            availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
            subnet_id = var.k8s_worker_subnet_id
        } 
        size = 1
    }
    node_source_details {
         image_id = var.node_image_id
         source_type = "image"
    }
}