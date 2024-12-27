variable "name" {
  description = "(Required) The name of the DNS A Record. Changing this forces a new resource to be created."
  type = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the resource group where the DNS Zone (parent resource) exists. Changing this forces a new resource to be created."
  type = string
}

variable "zone_name" {
  description = "(Required) Specifies the DNS Zone where the resource exists. Changing this forces a new resource to be created."
  type = string
}

variable "ttl" {
  description = "(Required) The Time To Live (TTL) of the DNS record in seconds."
  type = number
  default = 300
}

variable "records" {
  description = "(Required) List of IPv4 Addresses."
  type = list(string)
}
