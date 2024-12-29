variable "nsg" {
  description = "Manages a network security group that contains a list of network security rules. Network security groups enable inbound or outbound traffic to be enabled or denied."
  type = list(object({
    name                = string
    location            = string
    resource_group_name = string
    snet_association_id = string
  }))
}