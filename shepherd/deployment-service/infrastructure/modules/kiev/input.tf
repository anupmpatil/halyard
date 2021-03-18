variable "kiev_store_name" {
  type        = string
  description = "The Kiev store name."
}

variable "compartment_id" {
  type        = string
  description = "Compartment ID for the kiev instance related resources."
}

variable "environment" {
  type        = string
  description = "Environment of the log space. (beta/prod)"
}

variable "phone_book_name" {
  type        = string
  description = "Phonebook page guid"
}
