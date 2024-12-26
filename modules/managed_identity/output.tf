output "principal_id" {
  value = azurerm_user_assigned_identity.managed_identity.principal_id
}

output "id" {
  value = azurerm_user_assigned_identity.managed_identity.id
}
