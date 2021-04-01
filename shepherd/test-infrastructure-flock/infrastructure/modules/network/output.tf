output "test_public_subnet_id" {
  value       = oci_core_subnet.test_subnet_public.id
  description = "Public regional subnet that hosts instances used for testing."
}

output "test_private_subnet_id" {
  value       = oci_core_subnet.test_subnet_private.id
  description = "Private regional subnet used by oke nodepool"
}

output "test_vcn_id" {
  value       = oci_core_vcn.test_vcn.id
  description = "Test vcn id"
}