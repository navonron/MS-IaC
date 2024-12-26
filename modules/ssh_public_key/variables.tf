variable "name" {
  description = "(Required) The name of the Linux Virtual Machine. Changing this forces a new resource to be created."
  type = string
}

variable "location" {
  description = "(Required) The Azure location where the Linux Virtual Machine should exist. Changing this forces a new resource to be created."
  type = string
  default = "West Europe"
}

variable "parent_id" {
  description = "(Required) Resource Group id"
  type = string
}
