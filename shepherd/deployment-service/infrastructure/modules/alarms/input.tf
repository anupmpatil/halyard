variable "deployment_api_compartment_id" {
  type        = string
  description = "API Compartment ID for deployment service ODO application."
}

variable "deployment_worker_compartment_id" {
  type        = string
  description = "Worker Compartment ID for deployment service ODO application."
}

variable "jira_sd_queue" {
  type        = string
  description = "JIRA-SD Queue name"
}

variable "fleet_name_api" {
  type        = string
  description = "API microservice fleet name"
}

variable "fleet_name_worker" {
  type        = string
  description = "Worker microservice fleet name"
}

variable "t2_project_name" {
  type        = string
  description = "T2 project name"
}