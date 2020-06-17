variable "compartment_id" {
  type = string
  description = "Compartment ID for the secret related service."
}

variable "name_space" {
  type = string
  default = "deployment-service-api"
  description = "Name of the Namespace for the secrets."
}

variable "team_queue" {
  type = string
  description = "Team queue name of the service owner."
}
