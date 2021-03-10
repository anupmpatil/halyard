variable "canary_test_tenancy_ocid" {
  type        = string
  description = "Canary Test Tenancy ID"
}

variable "integ_test_tenancy_ocid" {
  type        = string
  description = "Integ Test Tenancy ID"
}

variable "environment" {
  type        = string
  description = "Environment in which the infrastructure is setup"
}

variable "api_public_key_path" {
  type        = string
  description = "Api public key file path"
}

