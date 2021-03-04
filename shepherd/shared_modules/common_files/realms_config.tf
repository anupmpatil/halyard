locals {
  onsr_realms = ["oc5", "oc6", "oc7"]
}

output "onsr_realms" {
  value = local.onsr_realms
}

