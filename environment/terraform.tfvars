resource_group = {
  rg1 = {
    name     = "dk_monday"
    location = "east asia"
  }
}

virtual_network = {
  vnet1 = {
    name                = "vnet_monday"
    address_space       = ["10.0.0.0/16"]
    location            = "east asia"
    resource_group_name = "dk_monday"
  }
}

subnet = {
  subnet1 = {
    name                 = "subnet_monday"
    resource_group_name  = "dk_monday"
    virtual_network_name = "vnet_monday"
    address_prefixes     = ["10.0.1.0/24"]
  }
}

pip = {
  pip1 = {
    name                = "pip_monday"
    resource_group_name = "dk_monday"
    location            = "east asia"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
}

vms = {
  vm1 = {
    nic_name             = "nic_monday"
    location             = "east asia"
    resource_group_name  = "dk_monday"
    ip_name              = "internal"
    subnet_name          = "subnet_monday"
    pip_name             = "pip_monday"
    vm_name              = "vm_monday"
    virtual_network_name = "vnet_monday"


  }
}

