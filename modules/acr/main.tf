resource "azurerm_container_registry" "acr" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
}

resource "azurerm_container_registry_scope_map" "acr_token_scope_map" {
  name                    = "${var.acr_token_name}-scope-map"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = var.resource_group_name
  actions                 = var.acr_token_scope_map_actions
}


resource "azurerm_container_registry_token" "acr_token" {
  name                    = var.acr_token_name
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = var.resource_group_name
  scope_map_id            = azurerm_container_registry_scope_map.acr_token_scope_map.id
}