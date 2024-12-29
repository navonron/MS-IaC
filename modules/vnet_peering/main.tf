resource "azurerm_virtual_network_peering" "vnet_peering" {
  for_each                  = {for idx, vnet_peering in var.vnet_peering : idx => vnet_peering}
  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.source_vnet_name
  remote_virtual_network_id = each.value.remote_vnet_id
}