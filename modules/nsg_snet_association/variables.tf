variable "nsg_id" {
  description = "(Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new resource to be created."
  type        = string
}

variable "snet_id" {
  description = "(Required) The ID of the Subnet. Changing this forces a new resource to be created."
  type        = string
}