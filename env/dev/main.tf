module "resource_group" {
  source = "../../modules/resource_group"
  name   = "${var.env}-rg"
}

module "spoke_vnet" {
  source              = "../../modules/vnet"
  name                = "${var.env}-vnet"
  location            = var.aks_location
  resource_group_name = module.resource_group.name
  address_space = [var.spoke_vnet_address_space]
}

module "aks_subnet" {
  source               = "../../modules/snet"
  name                 = "${var.env}-aks-snet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.spoke_vnet.name
  address_prefixes = [cidrsubnet(var.spoke_vnet_address_space, 8, 0)]
}

data "azurerm_virtual_network" "mgm_vnet" {
  name                = var.mgm_vnet_name
  resource_group_name = var.mgm_rg_name
}

module "vnet_peering_mgm_to_aks" {
  source              = "../../modules/vnet_peering"
  name                = "mgm_to_${var.env}"
  resource_group_name = data.azurerm_virtual_network.mgm_vnet.resource_group_name
  source_vnet_name    = data.azurerm_virtual_network.mgm_vnet.name
  remote_vnet_id      = module.spoke_vnet.id
}

module "vnet_peering_aks_to_mgm" {
  source              = "../../modules/vnet_peering"
  name                = "${var.env}_to_mgm"
  resource_group_name = module.resource_group.name
  source_vnet_name    = module.spoke_vnet.name
  remote_vnet_id      = data.azurerm_virtual_network.mgm_vnet.id
}

module "aks_managed_identity" {
  source              = "../../modules/managed_identity"
  name                = "${var.env}-aks-mi"
  location            = var.aks_location
  resource_group_name = module.resource_group.name
}

module "aks_role_assignment_on_spoke_vnet" {
  source               = "../../modules/role_assignment"
  scope                = module.spoke_vnet.id
  role_definition_name = "Contributor"
  principal_id         = module.aks_managed_identity.principal_id
}

module "aks" {
  source              = "../../modules/aks"
  name                = "${var.env}-aks"
  location            = var.aks_location
  resource_group_name = module.resource_group.name
  dns_prefix          = "${var.env}aks"
  default_node_pool = {
    name           = "np001"
    vnet_subnet_id = module.aks_subnet.id
  }
  service_cidr = cidrsubnet(var.spoke_vnet_address_space, 8, 1)
  dns_service_ip = cidrhost(cidrsubnet(var.spoke_vnet_address_space, 8, 1), 4)
  identity = {
    type = "UserAssigned"
    identity_ids = [module.aks_managed_identity.id]
  }
}

module "aks_role_assignment_on_aks_rg" {
  source               = "../../modules/role_assignment"
  scope                = module.aks.aks_resources_rg_id
  role_definition_name = "Contributor"
  principal_id         = module.aks_managed_identity.principal_id
}

# ALLOW ACCESS FROM SELF HOSTED GITHUB RUNNER TO AKS
module "aks_nsg" {
  source              = "../../modules/nsg"
  name                = "${var.env}-aks-nsg"
  location            = var.aks_location
  resource_group_name = module.aks.aks_resources_rg
  subnet_id           = module.aks_subnet.id
}

module "aks_nsg_rule" {
  source = "../../modules/nsg_rule"
  nsg_rules = [
    {
      name                        = "allow-acess-for-github-runner"
      priority                    = 100
      direction                   = "Inbound"
      resource_group_name         = module.aks.aks_resources_rg
      network_security_group_name = module.aks_nsg.name
    }
  ]
}

# TO SELF HOSTED GITHUB RUNNER VNET
module "aks_private_dns_zone_vnet_link" {
  source                = "../../modules/private_dns_zone_vnet_link"
  name                  = data.azurerm_virtual_network.mgm_vnet.name
  resource_group_name   = module.aks.aks_resources_rg
  private_dns_zone_name = regex("^[^.]+\\.(.*)", module.aks.private_fqdn)[0]
  virtual_network_id    = data.azurerm_virtual_network.mgm_vnet.id
}

module "nginx_ingress" {
  source                     = "../../modules/nginx_ingress"
  name                       = "${var.env}-ingress"
  k8s_host                   = module.aks.host
  k8s_client_certificate     = module.aks.client_certificate
  k8s_client_key             = module.aks.client_key
  k8s_cluster_ca_certificate = module.aks.cluster_ca_certificate
}
