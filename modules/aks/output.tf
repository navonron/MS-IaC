output "private_fqdn" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "dns_prefix_private_cluster" {
  value = azurerm_kubernetes_cluster.aks.dns_prefix_private_cluster
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