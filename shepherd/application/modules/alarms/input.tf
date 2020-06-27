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
