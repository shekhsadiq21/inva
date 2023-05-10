resource "azurerm_public_ip" "natgw_public_ip" {
  count = var.use_shared_app_gateway ? 0 : 1

  tags = merge(var.common_tags, {
    Tier = "Web"
  })

  name                = "pip-natgw-${var.resource_prefix}-${var.env}-${var.location}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "natgw" {
  count = var.use_shared_app_gateway ? 0 : 1

  tags = merge(var.common_tags, {
    Tier = "Web"
  })

  name                    = "natgw-${var.resource_prefix}-${var.env}-${var.location}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_pip_association" {
  count = var.use_shared_app_gateway ? 0 : 1

  nat_gateway_id       = azurerm_nat_gateway.natgw[0].id
  public_ip_address_id = azurerm_public_ip.natgw_public_ip[0].id
}

resource "azurerm_subnet_nat_gateway_association" "natgw_vmss_snet_association" {
  subnet_id      = var.vmss_subnet_id
  nat_gateway_id = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.nat_gateway_id : azurerm_nat_gateway.natgw[0].id
}