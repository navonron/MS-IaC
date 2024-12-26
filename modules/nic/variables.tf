variable "name" {
  description = "(Required) The name of the Network Interface. Changing this forces a new resource to be created."
  type = string
}

variable "location" {
  description = "(Required) The location where the Network Interface should exist. Changing this forces a new resource to be created."
  type = string
  default = "West Europe"
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which to create the Network Interface. Changing this forces a new resource to be created."
  type = string
}

variable "ip_configuration" {
  type = object({
    name = optional(string, "internal")
    subnet_id = string
    private_ip_address_allocation = optional(string, "Dynamic")
  })
}