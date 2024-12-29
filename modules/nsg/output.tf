output "name" {
  value = zipmap(
    [for nsg in var.nsg : nsg],
    values(azurerm_network_security_group.nsg)[*].name
  )
}