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
  default     = false
}


variable "acr_token_name" {
  description = "(Required) Specifies the name of the token. Changing this forces a new resource to be created."
  type        = string
}

variable "acr_token_scope_map_actions" {
  description = "(Required) A list of actions to attach to the scope map (e.g. repo/content/read, repo2/content/delete)."
  type = list(string)
  default = ["repositories/*/content/read", "repositories/*/content/write"]
}

variable "network_rule_set" {
  type = object({
    default_action = optional(string, "Allow")
    ip_rules = list(object({
      action = optional(string, "Allow")
      ip_range = string
    }))
  })
}