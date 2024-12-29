variable "snet" {
  description = "Manages a subnet. Subnets represent network segments within the IP space defined by the virtual network."
  type = list(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes = list(string)
  }))
}