variable "name" {
  description = "(Required) Specifies the name of this User Assigned Identity. Changing this forces a new User Assigned Identity to be created."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the User Assigned Identity should exist. Changing this forces a new User Assigned Identity to be created."
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group within which this User Assigned Identity should exist. Changing this forces a new User Assigned Identity to be created."
  type        = string
}
