resource "azurerm_container_registry" "acr" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  public_network_access_enabled = var.public_network_access_enabled

  network_rule_set {
    default_action = var.network_rule_set.default_action

    ip_rule = [
      for rule in var.network_rule_set.ip_rules : {
        action   = rule.action
        ip_range = rule.ip_range
      }
    ]
  }
}
