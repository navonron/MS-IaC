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
  resource_group_name = module.resource_group.name
  dns_prefix          = "${var.env}aks"
  default_node_pool = {
    name           = "np001"
    vnet_subnet_id = module.aks_subnet.id
  }
  service_cidr = cidrsubnet(var.address_space, 8, 1)
  dns_service_ip = cidrhost(cidrsubnet(var.address_space, 8, 1), 4)
}

module "connectivity_subnet" {
  source               = "../../modules/snet"
  name                 = "${var.env}-connectivity-snet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
  address_prefixes = [cidrsubnet(var.address_space, 8, 2)]
  depends_on = [module.vnet]
}

module "nic" {
  source              = "../../modules/nic"
  name                = "${var.env}-linux-vm-nic"
  resource_group_name = module.resource_group.name
  ip_configuration = {
    subnet_id = module.connectivity_subnet.id
  }
}

module "ssh_public_key" {
  source    = "../../modules/ssh_public_key"
  name      = "${var.env}-linux-vm-pk"
  parent_id = module.resource_group.id
}

module "linux_vm" {
  source              = "../../modules/linux_vm"
  name                = "${var.env}-linux-vm-pk"
  resource_group_name = module.resource_group.name
  network_interface_ids = [module.nic.id]
  public_key          = module.ssh_public_key.public_key
}