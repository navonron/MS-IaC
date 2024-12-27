output "private_fqdn" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "aks_resources_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "aks_resources_rg_id" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group_id
}

output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].host
}

output "client_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
}

output "client_key" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
}

output "cluster_ca_certificate" {
  value = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}