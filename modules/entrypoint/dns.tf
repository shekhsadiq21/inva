resource "azurerm_public_ip" "app_gw_public_ip" {
  count = var.use_shared_app_gateway ? 0 : 1

  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                = "pip-${var.resource_prefix}-${var.env}-${var.location}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

data "azurerm_dns_zone" "dns_zone" {
  provider            = azurerm.shared
  name                = var.dns_zone_name
  resource_group_name = var.dns_zone_rg_name
}

resource "azurerm_dns_a_record" "a_record" {
  provider            = azurerm.shared
  name                = "A-record-${var.resource_prefix}-${var.env}"
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = "rg-shared-inv-prod"
  ttl                 = 3600
  records             = [var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.appgw_ip_address : azurerm_public_ip.app_gw_public_ip[0].ip_address]
}

resource "azurerm_dns_cname_record" "peri_cname_record" {
  provider            = azurerm.shared
  name                = var.domain_name_label
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = "rg-shared-inv-prod"
  ttl                 = 3600
  record              = "${azurerm_dns_a_record.a_record.name}.invafresh.com"
}

resource "azurerm_dns_cname_record" "ws_cname_record" {
  provider            = azurerm.shared
  name                = "${var.domain_name_label}-ws"
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = "rg-shared-inv-prod"
  ttl                 = 3600
  record              = "${azurerm_dns_a_record.a_record.name}.invafresh.com"
}

resource "azurerm_dns_cname_record" "mo_cname_record" {
  provider            = azurerm.shared
  name                = "${var.domain_name_label}-mo"
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = "rg-shared-inv-prod"
  ttl                 = 3600
  record              = "${azurerm_dns_a_record.a_record.name}.invafresh.com"
}

resource "azurerm_dns_cname_record" "larry_cname_record" {
  provider            = azurerm.shared
  name                = "${var.domain_name_label}-larry"
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = "rg-shared-inv-prod"
  ttl                 = 3600
  record              = "${azurerm_dns_a_record.a_record.name}.invafresh.com"
}