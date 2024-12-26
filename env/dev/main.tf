module "resource_group" {
  source = "../../modules/resource_group"
  name   = "${var.env}-rg"
}

module "vnet" {
  source              = "../../modules/vnet"
  name                = "${var.env}-vnet"
  resource_group_name = module.resource_group.name
  address_space = [var.address_space]
}

data "azurerm_virtual_network" "mgm_vnet" {
  name                = var.mgm_vnet_name
  resource_group_name = var.mgm_rg_name
}

module "vnet_peering_mgm_to_aks" {
  source              = "../../modules/vnet_peering"
  name                = "mgm_to_aks"
  resource_group_name = data.azurerm_virtual_network.mgm_vnet.resource_group_name
  source_vnet_name    = data.azurerm_virtual_network.mgm_vnet.name
  remote_vnet_id      = module.vnet.id
  depends_on = [module.vnet]
}

module "vnet_peering_aks_to_mgm" {
  source              = "../../modules/vnet_peering"
  name                = "aks_to_mgm"
  resource_group_name = module.resource_group.name
  source_vnet_name    = module.vnet.name
  remote_vnet_id      = data.azurerm_virtual_network.mgm_vnet.id
  depends_on = [module.vnet]
}

module "aks_subnet" {
  source               = "../../modules/snet"
  name                 = "${var.env}-aks-snet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 0)]
  depends_on = [module.vnet]
}

module "aks" {
  source              = "../../modules/aks"
  name                = "${var.env}-aks"
  location            = "North Europe"
  resource_group_name = module.resource_group.name
  dns_prefix          = "${var.env}aks"
  default_node_pool = {
    name           = "np001"
    vnet_subnet_id = module.aks_subnet.id
  }
  service_cidr = cidrsubnet(var.address_space, 8, 1)
  dns_service_ip = cidrhost(cidrsubnet(var.address_space, 8, 1), 4)
  nginx_ingress_name = "${var.env}-ingress"
}

