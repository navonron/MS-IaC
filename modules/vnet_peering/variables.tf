variable "name" {
  description = "(Required) The name of the virtual network peering. Changing this forces a new resource to be created."
  type = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the virtual network peering. Changing this forces a new resource to be created."
  type = string
}

variable "source_vnet_name" {
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
  type = string
}

variable "remote_vnet_id" {
  description = "(Required) The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created."
  type = string
}