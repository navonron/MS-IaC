variable "name" {
  description = "(Required) The name of the Private DNS Zone. Must be a valid domain name. Changing this forces a new resource to be created."
  type = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the resource group where the resource exists. Changing this forces a new resource to be created."
  type = string
}
