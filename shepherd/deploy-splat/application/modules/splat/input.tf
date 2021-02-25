variable "service_name" {
  type        = string
  description = "The service name registered or to use to register in Splat."
}

variable "realm" {
  type        = string
  description = "The realm to use when register to Splat."
}

variable "compartment_id" {
  type        = string
  description = "The ocid of the compartment to use when register to Splat."
}

variable "splat_fleet" {
  type        = string
  description = "The Splat fleet to use when register to Splat."
}

variable "tenancy_name" {
  type        = string
  description = "The name of the tenancy where the service is running in."
}

variable "phone_book_id" {
  type        = string
  description = "The team phone book name for operational spec."
}

variable "lumberjack_namespace" {
  type        = string
  description = "The service's lumberjack namespace for operational spec."
}

variable "jump_page_link" {
  type        = string
  description = "The service's jump page for operational spec."
}

variable "telemetry_project" {
  type        = string
  description = "The service's telemetry project name for operational spec."
}

variable "telemetry_fleet" {
  type        = string
  description = "The service's telemetry fleet for operational spec."
}

variable "telemetry_key_alarm_names" {
  type        = list(any)
  description = "The list of telemetry key alarms of the service for operational spec."
}

variable "grafana_dashboard_names" {
  type        = list(any)
  description = "The list of Grafana dashboard names of the service for operational spec."
}

variable "endpoint" {
  type        = string
  description = "The service's downstream endpoint for downstream spec."
}

variable "host_headers" {
  type        = list(any)
  description = "The service's upstream (customer facing) domain name(s) for downstream spec."
}

variable "read_timeout_millis" {
  type        = number
  description = "Splat proxy read timeout before give 5xx error."
}

variable "api_yaml" {
  type        = string
  description = "The service's API spec to upload."
}

variable "rollout_duration_in_seconds" {
  type        = number
  description = "The duration rollout spec(s)."
}

