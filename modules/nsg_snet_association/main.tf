resource "azurerm_subnet_network_security_group_association" "nsg_snet_association" {
  subnet_id                 = var.snet_id
  network_security_group_id = var.nsg_id
}