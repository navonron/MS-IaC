output "id" {
  value = zipmap(
    [for snet in var.snet : snet],
    values(azurerm_subnet.snet)[*].id
  )
}

output "address_prefixes" {
  value = zipmap(
    [for snet in var.snet : snet],
    values(azurerm_subnet.snet)[*].address_prefixes
  )
}