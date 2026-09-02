module "resource_group" {
  source         = "../child_module/resource_group"
  resource_group = var.resource_group
}

module "virtual_network" {
  source          = "../child_module/virtual_network"
  virtual_network = var.virtual_network
  depends_on      = [module.resource_group]
}

module "subnet" {
  source     = "../child_module/subnet"
  subnet     = var.subnet
  depends_on = [module.virtual_network]
}

module "public_ip" {
  source     = "../child_module/public_ip"
  pip        = var.pip
  depends_on = [module.resource_group]
}

module "virtual_machine" {
  source     = "../child_module/virtual_machine"
  vms        = var.vms
  depends_on = [module.subnet]
}