module "resource_group" {
  source = "../../modules/resource_group"
  name   = "${var.env}-rg"
}

module "vnet" {
  source              = "../../modules/vnet"
  name                = "${var.env}-vnet"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space = [var.vnet_address_space]
}

/*
ENABLE CONNECTIVITY BETWEEN DEV SPOKE AND HUB
*/
data "azurerm_virtual_network" "mgm_vnet" {
  name                = var.mgm_vnet_name
  resource_group_name = var.mgm_rg_name
}

module "vnet_peering_mgm_to_aks" {
  source              = "../../modules/vnet_peering"
  name                = "mgm-to-${var.env}"
  resource_group_name = data.azurerm_virtual_network.mgm_vnet.resource_group_name
  source_vnet_name    = data.azurerm_virtual_network.mgm_vnet.name
  remote_vnet_id      = module.vnet.id
}

module "vnet_peering_aks_to_mgm" {
  source              = "../../modules/vnet_peering"
  name                = "${var.env}-to-mgm"
  resource_group_name = module.resource_group.name
  source_vnet_name    = module.vnet.name
  remote_vnet_id      = data.azurerm_virtual_network.mgm_vnet.id
}

module "aks_subnet" {
  source               = "../../modules/snet"
  name                 = "${var.env}-aks-snet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
  address_prefixes = [cidrsubnet(var.vnet_address_space, 8, 0)]
}

module "acr_subnet" {
  source               = "../../modules/snet"
  name                 = "${var.env}-acr-snet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
  address_prefixes = [cidrsubnet(var.vnet_address_space, 8, 2)]
}

module "acr" {
  source              = "../../modules/acr"
  name                = "${var.env}acrms"
  location            = var.location
  resource_group_name = module.resource_group.name
  sku = "Premium"  # Required for private endpoints
  acr_token_name      = "${var.env}-github-runner-token"
  network_rule_set = {
    ip_rules = [
      { ip_range = data.azurerm_virtual_network.mgm_vnet.address_space[0] }
    ]
  }
}

module "acr_private_dns" {
  source              = "../../modules/private_dns_zone"
  name                = "privatelink.azurecr.io"
  resource_group_name = module.resource_group.name
}

module "acr_private_endpoint" {
  source              = "../../modules/private_endpoint"
  name                = "${var.env}-acr-pe"
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.acr_subnet.id
  private_service_connection = {
    name                           = "acrPrivateConnection"
    private_connection_resource_id = module.acr.id
    is_manual_connection           = false
    subresource_name               = "registry"
  }
}

module "acr_private_dns_a_record" {
  source              = "../../modules/private_dns_a_record"
  name                = module.acr.name
  zone_name           = module.acr_private_dns.name
  resource_group_name = module.resource_group.name
  records = [module.acr_private_endpoint.ip]
}

/*
INGRESS DEPLOYMENT REQUIREMENTS
*/
module "aks_managed_identity" {
  source              = "../../modules/managed_identity"
  name                = "${var.env}-aks-mi"
  location            = var.location
  resource_group_name = module.resource_group.name
}

module "aks_role_assignment_on_spoke_vnet" {
  source               = "../../modules/role_assignment"
  scope                = module.vnet.id
  role_definition_name = "Contributor"
  principal_id         = module.aks_managed_identity.principal_id
}

module "aks_role_assignment_on_acr" {
  source               = "../../modules/role_assignment"
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_managed_identity.principal_id
}

module "aks" {
  source              = "../../modules/aks"
  name                = "${var.env}-aks"
  location            = var.location
  resource_group_name = module.resource_group.name
  dns_prefix          = "${var.env}aks"
  default_node_pool = {
    name           = "np001"
    vnet_subnet_id = module.aks_subnet.id
  }
  service_cidr = cidrsubnet(var.vnet_address_space, 8, 1)
  dns_service_ip = cidrhost(cidrsubnet(var.vnet_address_space, 8, 1), 4)
  identity = {
    type = "UserAssigned"
    identity_ids = [module.aks_managed_identity.id]
  }
}

/*
ALLOW ACCESS FROM SELF HOSTED GITHUB RUNNER TO AKS
*/
module "aks_nsg" {
  source              = "../../modules/nsg"
  name                = "${var.env}-aks-nsg"
  location            = var.location
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

/*
ENABLE NAME RESOLUTION TO SELF HOSTED GITHUB RUNNER ON HUB VNET TO SPOKE
*/
module "aks_private_dns_zone_mgm_vnet_link" {
  source                = "../../modules/private_dns_zone_vnet_link"
  name                  = data.azurerm_virtual_network.mgm_vnet.name
  resource_group_name   = module.aks.aks_resources_rg
  private_dns_zone_name = regex("^[^.]+\\.(.*)", module.aks.private_fqdn)[0]
  virtual_network_id    = data.azurerm_virtual_network.mgm_vnet.id
}

module "acr_private_dns_zone_spoke_vnet_link" {
  source                = "../../modules/private_dns_zone_vnet_link"
  name                  = module.vnet.name
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = module.acr_private_dns.name
  virtual_network_id    = module.vnet.id
}

module "acr_private_dns_zone_mgm_vnet_link" {
  source                = "../../modules/private_dns_zone_vnet_link"
  name                  = data.azurerm_virtual_network.mgm_vnet.name
  resource_group_name   = module.resource_group.name
  private_dns_zone_name = module.acr_private_dns.name
  virtual_network_id    = data.azurerm_virtual_network.mgm_vnet.id
}

module "nginx_ingress" {
  source                     = "../../modules/nginx_ingress"
  name                       = "${var.env}-nginx-ingress"
  k8s_host                   = module.aks.host
  k8s_client_certificate     = module.aks.client_certificate
  k8s_client_key             = module.aks.client_key
  k8s_cluster_ca_certificate = module.aks.cluster_ca_certificate
}
