variable "nsg_rules" {
  type = list(object({
    name                        = string
    priority                    = number
    direction                   = string
    access                      = optional(string, "Allow")
    protocol                    = optional(string, "*")
    source_port_range           = optional(string, "*")
    destination_port_range      = optional(string, "*")
    source_address_prefix       = optional(string, "*")
    destination_address_prefix  = optional(string, "*")
    resource_group_name         = string
    network_security_group_name = string
  }))
}