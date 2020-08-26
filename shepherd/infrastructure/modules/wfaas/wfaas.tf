resource "wfaas_instance" wfaas_instance {
  ad             = var.availability_domains[0]
  name           = var.wfaas_name
  compartment_id = var.deployment_worker_compartment_id
  type           = var.type
  cell           = var.cell
}