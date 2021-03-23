variable "control_plane_api_compartment_id" {
  type        = string
  description = "API Compartment ID for deployment service ODO application."
}

variable "control_plane_worker_compartment_id" {
  type        = string
  description = "Worker Compartment ID for deployment service ODO application."
}

variable "management_plane_api_compartment_id" {
  type        = string
  description = "API Compartment ID for deployment service ODO application."
}

variable "data_plane_worker_compartment_id" {
  type        = string
  description = "Worker Compartment ID for deployment service ODO application."
}

variable "jira_sd_queue" {
  type        = string
  description = "JIRA-SD Queue name"
}

variable "control_plane_api_fleet_name" {
  type        = string
  description = "Control Plane API microservice fleet name"
}

variable "control_plane_worker_fleet_name" {
  type        = string
  description = "Control Plane Worker microservice fleet name"
}

variable "management_plane_api_fleet_name" {
  type        = string
  description = "Management Plane API microservice fleet name"
}

variable "data_plane_worker_fleet_name" {
  type        = string
  description = "Data Plane Worker microservice fleet name"
}

variable "t2_project_name" {
  type        = string
  description = "T2 project name"
}