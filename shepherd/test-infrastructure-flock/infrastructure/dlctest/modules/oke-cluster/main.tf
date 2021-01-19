resource "oci_containerengine_cluster" "test-oke-cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_cluster_version
  name               = "customet test k8s Cluster"
  vcn_id             = var.vcn_id

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
  }
}

data "oci_identity_availability_domains" "availability_domains" {
  #Required
  compartment_id = var.tenancy_ocid
}

resource "oci_containerengine_node_pool" "test-node_pool1" {
  #Required
  cluster_id         = oci_containerengine_cluster.test-oke-cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_cluster_version
  name               = "test node pool for oke cluster"
  node_shape         = "VM.Standard1.1"
  node_image_id      = var.node_image_id

  node_config_details {
    dynamic "placement_configs" {
      for_each = data.oci_identity_availability_domains.availability_domains.availability_domains
      content {
        availability_domain = placement_configs.value["name"]
        subnet_id           = var.k8s_worker_subnet_id
      }
    }
    size = 3
  }
}