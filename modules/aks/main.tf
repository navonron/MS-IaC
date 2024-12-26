resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  private_cluster_enabled = var.private_cluster_enabled
  dns_prefix              = var.dns_prefix

  default_node_pool {
    name           = var.default_node_pool.name
    node_count     = var.default_node_pool.node_count
    vm_size        = var.default_node_pool.vm_size
    vnet_subnet_id = var.default_node_pool.vnet_subnet_id
  }

  network_profile {
    network_plugin = var.network_plugin
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  identity {
    type = var.identity
  }
}

provider "kubernetes" {
  host = azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
}

resource "helm_release" "nginx_ingress" {
  name             = var.nginx_ingress_name
  namespace        = var.nginx_ingress_namespace
  chart            = var.nginx_ingress_chart
  repository       = var.nginx_ingress_repository
  version          = var.nginx_ingress_version
  create_namespace = var.nginx_ingress_create_namespace
  values           = var.nginx_ingress_values
}