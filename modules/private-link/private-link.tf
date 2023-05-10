provider "azurerm" {
  features {}
  alias                      = "ss"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
}

data "azurerm_private_dns_zone" "private_dns" {
  provider            = azurerm.ss
  name                = "privatelink.database.windows.net"
  resource_group_name = var.ss_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "main_dns_zone_to_vnet_link" {
  provider              = azurerm.ss
  name                  = "main-dns-zone-link-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name   = var.ss_resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = var.main_vnet_id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "data_dns_zone_to_vnet_link" {
  provider              = azurerm.ss
  name                  = "data-dns-zone-link-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name   = var.ss_resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = var.data_vnet_id
  registration_enabled  = true
}

resource "azurerm_private_endpoint" "sql_endpoint" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Database"
  })
  name                = "pl-sql-endpoint-${var.resource_prefix}-${var.env}-${var.location}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "pl-sql-serviceconnection-${var.resource_prefix}-${var.env}-${var.location}-001"
    private_connection_resource_id = var.sql_server_id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}

data "azurerm_private_endpoint_connection" "sql_endpoint_connection" {
  name                = azurerm_private_endpoint.sql_endpoint.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_a_record" "sql_endpoint_dns_a_record" {
  count               = var.is_small_environment ? 0 : 1
  provider            = azurerm.ss
  name                = lower(var.sql_server_name)
  zone_name           = data.azurerm_private_dns_zone.private_dns.name
  resource_group_name = var.ss_resource_group_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.sql_endpoint_connection.private_service_connection.0.private_ip_address]
}

resource "azurerm_private_endpoint" "redis_endpoint" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Database"
  })

  name                = "pl-redis-endpoint-${var.resource_prefix}-${var.env}-${var.location}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.redis_subnet_id

  private_service_connection {
    name                           = "pl-redis-serviceconnection-${var.resource_prefix}-${var.env}-${var.location}-001"
    private_connection_resource_id = var.redis_id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }
}

moved {
  from = azurerm_private_endpoint.redis_endpoint[0]
  to   = azurerm_private_endpoint.redis_endpoint
}

data "azurerm_private_endpoint_connection" "redis_endpoint_connection" {
  name                = azurerm_private_endpoint.redis_endpoint.name
  resource_group_name = var.resource_group_name
}

moved {
  from = azurerm_private_endpoint_connection.redis_endpoint_connection[0]
  to   = azurerm_private_endpoint_connection.redis_endpoint_connection
}

resource "azurerm_private_dns_a_record" "redis_endpoint_dns_a_record" {
  provider            = azurerm.ss
  name                = lower(var.redis_name)
  zone_name           = data.azurerm_private_dns_zone.private_dns.name
  resource_group_name = var.ss_resource_group_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.redis_endpoint_connection.private_service_connection.0.private_ip_address]
}

moved {
  from = azurerm_private_dns_a_record.redis_endpoint_dns_a_record[0]
  to   = azurerm_private_dns_a_record.redis_endpoint_dns_a_record
}
