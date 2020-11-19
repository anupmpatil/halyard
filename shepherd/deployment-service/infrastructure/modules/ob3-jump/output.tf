/*
  Outputs of this module. User will need these information to set up their local
  environment and the bastion ssh tunnel.
*/
output "jump_instance_ip" {
  value       = oci_core_instance.jump_instance.private_ip
  description = "The privateIp of the jump instance, which should be put to the user's ssh config file."
}

output "ob3_jump_vcn_lpt" {
  value       = oci_core_local_peering_gateway.ob3_lpg.id
  description = "The ID of the LPG connecting overlay bastion hosts and the jump instance. Needs to provide this to the SecEdge team so they can pair the two networks"
}


output "os_updater_bastion" {
  value       = odo_application.os_updater_bastion
  description = "ODO OS_Updater Application"
}