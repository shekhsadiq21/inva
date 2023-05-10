resource "azurerm_subnet" "vmss_subnet" {
  name                 = "snet-${var.resource_prefix}-${var.env}-${var.location}-vmss"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.vmss_subnet]
}

resource "azurerm_subnet" "data_subnet" {
  name                                           = "snet-data-${var.resource_prefix}-${var.env}-${var.location}"
  resource_group_name                            = var.data_resource_group_name
  virtual_network_name                           = var.data_vnet_name
  address_prefixes                               = [var.data_subnet]
  enforce_private_link_endpoint_network_policies = true # disable the policies
}

resource "azurerm_subnet" "redis_subnet" {
  name                                           = "snet-redis-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name                            = var.data_resource_group_name
  virtual_network_name                           = var.data_vnet_name
  address_prefixes                               = [var.redis_subnet]
  enforce_private_link_endpoint_network_policies = true # disable the policies
}
