output "name" {
  value = zipmap(
    [for idx, nsg in var.nsg : idx], # Use the index as the key
    values(azurerm_network_security_group.nsg)[*].name
  )
}