variable "canaries_list" {
  type        = list(string)
  description = "The list of canary names"
  default     = ["deploy-dummy-canary"]
}

variable "canary_frequency_map" {
  type        = map(any)
  description = "The mapping of canary name to the frequency of the canary"
  default = {
    "deploy-dummy-canary" = "*/5 * * * *"
  }
}

variable "canary_maxruntime_map" {
  type        = map(any)
  description = "The mapping of canary name to the maximum runtime of the canary"
  default = {
    "deploy-dummy-canary" = 10
  }
}

variable "canaries_test_method_map" {
  type        = map(any)
  description = "The mapping of canary name to the TEST_METHOD of the canary"
  default = {
    "deploy-dummy-canary" = "DummyIT.helloWorld"
  }
}

variable "canaries_compartment_id_map" {
  type        = map(any)
  description = "The mapping of environment to compartment id for the canaries"
  default = {
    "beta"    = "ocid1.compartment.oc1..aaaaaaaajhenmkeafdssqt2egxykpbhoswvgjrselml52t3osvknpuq2zjxa"
    "preprod" = "ocid1.compartment.oc1..aaaaaaaadepgi3okejgy2hcwl4kdymz5lggpqajpacwh3iveuszm3gliraja"
    "oc1"     = "ocid1.compartment.oc1..aaaaaaaanjlnhtoqtkvzudjdbslifk333xbvi5dckr5fypd5niapdmxw3yja"
  }
}

output "canaries_list" {
  value = var.canaries_list
}

output "canary_frequency_map" {
  value = var.canary_frequency_map
}

output "canary_maxruntime_map" {
  value = var.canary_maxruntime_map
}

output "canaries_test_method_map" {
  value = var.canaries_test_method_map
}

output "canaries_compartment_id_map" {
  value = var.canaries_compartment_id_map
}

