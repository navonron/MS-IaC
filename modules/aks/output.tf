output "private_fqdn" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "aks_resources_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "aks_nsg" {
  value = azurerm_kubernetes_cluster.aks.node
}

output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].host
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
}