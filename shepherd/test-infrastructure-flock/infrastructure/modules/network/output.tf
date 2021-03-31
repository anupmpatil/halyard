output "ig_test_subnet_id" {
  value       = oci_core_subnet.ig_test_subnet.id
  description = "The regional subnet that hosts instances used for testing."
}

output "ig_test_vcn_id" {
  value       = oci_core_vcn.ig_test_vcn.id
  description = "The vcn id"
}