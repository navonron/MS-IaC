variable "vnet_peering" {
  description = "Manages a virtual network peering which allows resources to access other resources in the linked virtual network."
  type = list(object({
    name                = string
    resource_group_name = string
    source_vnet_name    = string
    remote_vnet_id      = string
  }))
}