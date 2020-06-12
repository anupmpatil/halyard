variable "environment" {
  type = string
  description = "Environment for current deployment e.g. beta, prod1, prod2 etc."
}

variable "region_short" {
  type = string
  description = "The short form of region e.g. iad, phx."
}

variable "realm" {
  type = string
  description = "The realm for current deployment e.g. oc1, oc2 etc."
}