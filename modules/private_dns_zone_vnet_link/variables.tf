variable "name" {
  description = "(Required) The name of the Private DNS Zone Virtual Network Link. Changing this forces a new resource to be created."
  type = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the resource group where the Private DNS Zone exists. Changing this forces a new resource to be created."
  type = string
}


variable "private_dns_zone_name" {
  description = "(Required) The name of the Private DNS zone (without a terminating dot). Changing this forces a new resource to be created."
  type = string
}


variable "virtual_network_id" {
  description = "(Required) The ID of the Virtual Network that should be linked to the DNS Zone. Changing this forces a new resource to be created."
  type = string
}
