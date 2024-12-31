variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "sku" {
  description = "(Required) The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Basic"
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for the container registry. Defaults to true."
  type        = bool
  default     = true
}

variable "network_rule_set" {
  type = object({
    default_action = optional(string, "Deny")
    ip_rules = list(object({
      action = optional(string, "Allow")
      ip_range = string
    }))
  })
}

# variable "identity" {
#   description = "(Required) Specifies the type of Managed Service Identity that should be configured on this Kubernetes Cluster. Possible values are SystemAssigned or UserAssigned."
#   type = object({
#     type = optional(string, "SystemAssigned")
#     identity_ids = optional(list(string))
#   })
# }
#
# variable "encryption" {
#   description = "(Required) Specifies the type of Managed Service Identity that should be configured on this Kubernetes Cluster. Possible values are SystemAssigned or UserAssigned."
#   type = object({
#     kv_id = string
#     identity_client_id = string
#   })
# }
