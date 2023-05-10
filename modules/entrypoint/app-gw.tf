locals {
  backend_address_pool_name      = "${var.vnet_name}-beap"
  frontend_port_name             = "${var.vnet_name}-feport"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"
  http_setting_name              = "${var.vnet_name}-be-htst"
  listener_name                  = "${var.vnet_name}-httplstn"
  request_routing_rule_name      = "${var.vnet_name}-rqrt"
}

resource "azurerm_subnet" "app_gw_subnet" {
  count = var.use_shared_app_gateway ? 0 : 1

  name                 = "snet-${var.resource_prefix}-${var.env}-${var.location}-agw"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.app_gw_subnet]
}

resource "azurerm_web_application_firewall_policy" "fwpolicy" {
  count = var.use_shared_app_gateway ? 0 : 1

  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                = "fwp-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    enabled                     = true
    mode                        = "Detection"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  custom_rules {
    name      = "AllowCustomerAndDatadogIPsOnly"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }

      operator           = "IPMatch"
      negation_condition = true
      match_values       = concat(var.authorized_ip_ranges, var.datadog_synthetic_ip_ranges)
    }

    action = "Block"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.1"
    }
  }
}

resource "azurerm_application_gateway" "app_gw" {
  count = var.use_shared_app_gateway ? 0 : 1

  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                = "agw-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewall_policy_id  = azurerm_web_application_firewall_policy.fwpolicy[0].id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.agw_identity_id]
  }

  sku {
    name     = var.app_gw_sku
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.app_gw_subnet[0].id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  ssl_certificate {
    name                = var.ssl_cert_name
    key_vault_secret_id = var.ssl_cert_secret_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gw_public_ip[0].id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 300
    probe_name            = "Periscope-Probe"
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}-ws"
    cookie_based_affinity = "Disabled"
    port                  = 5803
    protocol              = "Http"
    request_timeout       = 300
    probe_name            = "WS-Probe"
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}-mo"
    cookie_based_affinity = "Disabled"
    port                  = 6443
    protocol              = "Https"
    request_timeout       = 300
    probe_name            = "Mo-Probe"
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}-larry"
    cookie_based_affinity = "Disabled"
    port                  = 8000
    protocol              = "Https"
    request_timeout       = 300
    probe_name            = "Larry-Probe"
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_cert_name
    host_name                      = "${var.domain_name_label}.invafresh.com"
  }


  http_listener {
    name                           = "${local.listener_name}-mo"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_cert_name
    host_name                      = "${var.domain_name_label}-mo.invafresh.com"
  }
  http_listener {
    name                           = "${local.listener_name}-ws"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_cert_name
    host_name                      = "${var.domain_name_label}-ws.invafresh.com"
  }

  http_listener {
    name                           = "${local.listener_name}-larry"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_cert_name
    host_name                      = "${var.domain_name_label}-larry.invafresh.com"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}-larry"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}-larry"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = "${local.http_setting_name}-larry"
    priority                   = 40
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 30
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}-ws"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}-ws"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = "${local.http_setting_name}-ws"
    rewrite_rule_set_name      = "rewrite-rule-set-ws"
    priority                   = 20
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}-mo"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}-mo"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = "${local.http_setting_name}-mo"
    priority                   = 10
  }

  probe {
    name                = "Periscope-Probe"
    host                = "${var.domain_name_label}.invafresh.com"
    interval            = 30
    protocol            = "Https"
    path                = "/periscope/"
    timeout             = 30
    unhealthy_threshold = 3
  }

  probe {
    name                = "WS-Probe"
    host                = "${var.domain_name_label}-ws.invafresh.com"
    interval            = 30
    protocol            = "Http"
    path                = "/"
    timeout             = 30
    unhealthy_threshold = 3
    port                = 5803
  }

  probe {
    name                = "Mo-Probe"
    host                = "${var.domain_name_label}-mo.invafresh.com"
    interval            = 30
    protocol            = "Https"
    path                = "/pocketperiscope/"
    timeout             = 30
    unhealthy_threshold = 3
    port                = 6443
  }

  probe {
    name                = "Larry-Probe"
    host                = "${var.domain_name_label}-larry.invafresh.com"
    interval            = 30
    protocol            = "Https"
    path                = "/health_check"
    timeout             = 30
    unhealthy_threshold = 3
    port                = 8000
  }

  rewrite_rule_set {
    name = "rewrite-rule-set-ws"
    rewrite_rule {
      name          = "redirect-indexhtml-test-to-404"
      rule_sequence = 100

      condition {
        variable = "var_uri_path"
        pattern  = "index.html"
      }

      condition {
        variable = "var_query_string"
        pattern  = "test=1"
      }

      url {
        path = "404.html"
      }

    }
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.app_gw[0],
  ]
}

resource "azurerm_monitor_diagnostic_setting" "agw_sentinel" {
  count = var.use_shared_app_gateway ? 0 : 1

  name                       = "SendtoLogAnalyticsWorkspace_Sentinel"
  target_resource_id         = azurerm_application_gateway.app_gw[0].id
  log_analytics_workspace_id = var.log_workspace_id

  log {
    category = "ApplicationGatewayAccessLog"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayFirewallLog"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayPerformanceLog"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "agw_shared_logs" {
  count = var.use_shared_app_gateway ? 0 : 1

  name                       = "SendtoLogAnalyticsWorkspace_SharedServices"
  target_resource_id         = azurerm_application_gateway.app_gw[0].id
  log_analytics_workspace_id = var.second_log_workspace_id

  log {
    category = "ApplicationGatewayAccessLog"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayFirewallLog"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayPerformanceLog"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "app_gw" {
  count = var.use_shared_app_gateway ? 0 : 1

  subnet_id                 = azurerm_subnet.app_gw_subnet[0].id
  network_security_group_id = azurerm_network_security_group.appgw_nsg[0].id
}

resource "azurerm_network_security_group" "appgw_nsg" {
  count = var.use_shared_app_gateway ? 0 : 1

  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                = "nsg-appgw-${var.resource_prefix}-${var.env}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowTraffic_To_AppGW"
    description                = ""
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "80"]
    source_address_prefix      = ""
    source_address_prefixes    = concat(var.authorized_ip_ranges, var.datadog_synthetic_ip_ranges, [azurerm_public_ip.natgw_public_ip[0].ip_address])
    destination_address_prefix = var.app_gw_subnet
  }

  security_rule {
    name                       = "AllowAppGW_HealthProbe"
    description                = ""
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAzureLB_Inbound"
    description                = ""
    priority                   = 4010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAll"
    description                = ""
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "time_sleep" "app_gw_nsg_rule_change_propagation" {
  count = var.use_shared_app_gateway ? 0 : 1

  create_duration = "120s"

  triggers = {
    appgw_nsg_rules = sha256(jsonencode(azurerm_network_security_group.appgw_nsg[0].security_rule))
  }
}

#### SHARED APP GATEWAY CONFIG

data "azurerm_storage_table_entity" "shared_app_gw_config" {
  count    = var.use_shared_app_gateway ? 1 : 0
  provider = azurerm.shared

  storage_account_name = var.shared_config_management_storage_account_name
  table_name           = var.shared_config_management_table_name
  partition_key        = "${var.resource_prefix}-${var.env}"
  row_key              = "shared-app-gw"
}

resource "azurerm_virtual_network_peering" "main_to_appgw" {
  count = var.use_shared_app_gateway ? 1 : 0

  name                         = "vnet-peer-appgw-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.vnet_name
  remote_virtual_network_id    = data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "appgw_to_main" {
  count = var.use_shared_app_gateway ? 1 : 0

  name                         = "vnet-peer-main-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.resource_group_name
  virtual_network_name         = data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.vnet_name
  remote_virtual_network_id    = var.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [
    azurerm_virtual_network_peering.main_to_appgw
  ]
}
