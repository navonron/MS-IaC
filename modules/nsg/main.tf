resource "azurerm_network_security_group" "nsg" {
  for_each            = {for idx, nsg in var.nsg : idx => nsg}
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

module "nsg_snet_association" {
  source   = "../nsg_snet_association"
  for_each = {for idx, nsg in var.nsg : idx => nsg}
  nsg_id   = azurerm_network_security_group.nsg[idx].id
  snet_id  = each.value.snet_association_id
}