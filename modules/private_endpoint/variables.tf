variable "name" {
  description = "(Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) The supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "(Required) Specifies the Name of the Resource Group within which the Private Endpoint should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
  type        = string
}

variable "private_service_connection" {
  type = object({
    name                           = string
    is_manual_connection           = bool
    private_connection_resource_id = string
  })
}