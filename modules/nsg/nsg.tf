locals {
  az_vpn_ip_range      = "172.21.0.0/24"
  jumpserver_ip_range  = "172.20.2.0/24"
  cisco_vpn_ip_range_1 = "192.0.12.0/24"
  cisco_vpn_ip_range_2 = "192.0.250.128/25"
  jmeter_ip            = "23.96.13.138"
  jenkins_ip           = "172.30.7.4"
  cisco_vpn_ip_range_3 = "192.168.250.0/24"
  cisco_vpn_ip_range_4 = "192.168.251.0/24"
}

resource "azurerm_network_security_group" "main_nsg" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                = "nsg-main-${var.resource_prefix}-${var.env}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                                       = "AllowWebTier_To_MQTier"
    description                                = ""
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "5800"
    source_address_prefix                      = ""
    source_application_security_group_ids      = [var.asg_web_id]
    destination_address_prefix                 = ""
    destination_application_security_group_ids = [var.asg_mq_id]
  }

  security_rule {
    name                                       = "AllowAppTier_To_MQTier"
    description                                = ""
    priority                                   = 120
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "5800-5801"
    source_address_prefix                      = ""
    source_application_security_group_ids      = [var.asg_app_id]
    destination_address_prefix                 = ""
    destination_application_security_group_ids = [var.asg_mq_id]
  }
  security_rule {
    name                                       = "AllowAppTier_To_MQTier_for_debug_mode"
    description                                = ""
    priority                                   = 210
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "5803"
    source_address_prefix                      = ""
    source_application_security_group_ids      = [var.asg_app_id]
    destination_address_prefix                 = ""
    destination_application_security_group_ids = [var.asg_mq_id]
  }

  security_rule {
    name                                       = "AllowAppTier_To_ESHATier"
    description                                = ""
    priority                                   = 121
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "5803"
    source_address_prefix                      = ""
    source_application_security_group_ids      = [var.asg_app_id]
    destination_address_prefix                 = ""
    destination_application_security_group_ids = [var.asg_esha_id]
  }

  security_rule {
    name                                       = "AllowAppGWAzVPNJumpSrvs_To_WebTier"
    description                                = ""
    priority                                   = 140
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = ""
    destination_port_ranges                    = ["5804", "5803", "443", "80", "6443", "8000"]
    source_address_prefix                      = ""
    source_address_prefixes                    = concat([local.az_vpn_ip_range, local.jumpserver_ip_range, local.cisco_vpn_ip_range_1, local.cisco_vpn_ip_range_2, local.cisco_vpn_ip_range_3, local.cisco_vpn_ip_range_4, var.app_gw_subnet], var.env == "qa" ? [local.jmeter_ip] : [])
    destination_address_prefix                 = ""
    destination_application_security_group_ids = [var.asg_web_id]
  }

  security_rule {
    name                       = "AllowAzVPN_RDP_Access"
    description                = ""
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = ""
    source_address_prefixes    = [local.az_vpn_ip_range, local.cisco_vpn_ip_range_1, local.cisco_vpn_ip_range_2, local.cisco_vpn_ip_range_3, local.cisco_vpn_ip_range_4]
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowAzVPN_To_ICMP_Access"
    description                = ""
    priority                   = 170
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = [local.az_vpn_ip_range, local.cisco_vpn_ip_range_3, local.cisco_vpn_ip_range_4]
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowJumpServer_RDP_Access"
    description                = ""
    priority                   = 180
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = local.jumpserver_ip_range
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowJumpServer_To_ICMP_Access"
    description                = ""
    priority                   = 190
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = local.jumpserver_ip_range
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                                       = "AllowAzVPN_JumpServer_rMQ"
    description                                = ""
    priority                                   = 200
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "5800"
    source_address_prefix                      = ""
    source_address_prefixes                    = [local.az_vpn_ip_range, local.jumpserver_ip_range, local.cisco_vpn_ip_range_2, local.cisco_vpn_ip_range_3, local.cisco_vpn_ip_range_4, var.env == "qa" ? local.jenkins_ip : local.cisco_vpn_ip_range_1, var.env == "dev" ? local.jenkins_ip : local.cisco_vpn_ip_range_1]
    destination_address_prefix                 = ""
    destination_application_security_group_ids = [var.asg_mq_id]
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

  security_rule {
    name                                  = "AllowSMTPS_Port_TCP587"
    description                           = ""
    priority                              = 110
    direction                             = "Outbound"
    access                                = "Allow"
    protocol                              = "*"
    source_port_range                     = "*"
    destination_port_range                = "587"
    source_address_prefix                 = ""
    source_application_security_group_ids = [var.asg_web_id]
    destination_address_prefix            = "Internet"
  }

  security_rule {
    name                                  = "PermitSQL_AppTierESHATier_To_DataSNET"
    description                           = ""
    priority                              = 210
    direction                             = "Outbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "1433"
    source_address_prefix                 = ""
    source_application_security_group_ids = [var.asg_app_id, var.asg_esha_id]
    destination_address_prefix            = var.data_subnet
  }

  security_rule {
    name                                  = "PermitRedis_WebTier_To_RedisSNET"
    description                           = ""
    priority                              = 220
    direction                             = "Outbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "6380"
    source_address_prefix                 = ""
    source_application_security_group_ids = [var.asg_web_id]
    destination_address_prefix            = var.redis_subnet
  }

  security_rule {
    name                                  = "BlockMQTier_Any_To_DataVNET"
    description                           = ""
    priority                              = 4094
    direction                             = "Outbound"
    access                                = "Deny"
    protocol                              = "*"
    source_port_range                     = "*"
    destination_port_range                = "*"
    source_address_prefix                 = ""
    source_application_security_group_ids = [var.asg_mq_id]
    destination_address_prefix            = ""
    destination_address_prefixes          = [var.data_subnet, var.redis_subnet]
  }

  security_rule {
    name                                  = "BlockWebTier_Any_To_DataVNET"
    description                           = ""
    priority                              = 4095
    direction                             = "Outbound"
    access                                = "Deny"
    protocol                              = "*"
    source_port_range                     = "*"
    destination_port_range                = "*"
    source_address_prefix                 = ""
    source_application_security_group_ids = [var.asg_web_id]
    destination_address_prefix            = ""
    destination_address_prefixes          = [var.data_subnet, var.redis_subnet]
  }

  security_rule {
    name                                  = "BlockAppAndEshaTier_Any_To_DataVNET"
    description                           = ""
    priority                              = 4096
    direction                             = "Outbound"
    access                                = "Deny"
    protocol                              = "*"
    source_port_range                     = "*"
    destination_port_range                = "*"
    source_address_prefix                 = ""
    source_application_security_group_ids = [var.asg_app_id, var.asg_esha_id]
    destination_address_prefix            = ""
    destination_address_prefixes          = [var.data_subnet, var.redis_subnet]
  }

}

resource "azurerm_network_security_group" "data_nsg" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Database"
  })
  name                = "nsg-data-${var.resource_prefix}-${var.env}-${var.location}"
  location            = var.location
  resource_group_name = var.data_resource_group_name

  security_rule {
    name                                  = "AllowESHATier_To_MSSQL"
    description                           = ""
    priority                              = 250
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "1433"
    source_address_prefix                 = ""
    source_application_security_group_ids = [var.asg_esha_id]
    destination_address_prefix            = "VirtualNetwork"
  }

  security_rule {
    name                                  = "AllowAppTier_To_MSSQL"
    description                           = ""
    priority                              = 260
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "1433"
    source_address_prefix                 = ""
    source_application_security_group_ids = [var.asg_app_id]
    destination_address_prefix            = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowJumpServer_To_MSSQL"
    description                = ""
    priority                   = 270
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefixes    = [local.jumpserver_ip_range, local.jenkins_ip]
    destination_address_prefix = "VirtualNetwork"
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

  security_rule {
    name                       = "AllowVirtualNetwork_To_VirtualNetwork"
    description                = ""
    priority                   = 500
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "DenyAllOutbound"
    description                = ""
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAnalyticsPlatform_To_MSSQL"
    description                = ""
    priority                   = 500
    direction                  = "Inbound"
    access                     = var.connect_with_ffrp_analytics_env_flag == true ? "Allow" : "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = var.ffrp_analytics_vnet_address_space
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "vmss" {
  subnet_id                 = var.vmss_subnet_id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = var.data_subnet_id
  network_security_group_id = azurerm_network_security_group.data_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "redis" {
  subnet_id                 = var.redis_subnet_id
  network_security_group_id = azurerm_network_security_group.data_nsg.id
}

# NSG rule change propagation takes 1 to 2min in Azure network
# This resource is needed to wait 120s after any change to NSG rules
# So the manual datadog synthetic tests after the terraform apply step can access the vnet with the newest network rules
# security rules of each NSG is encoded in json to get a string then a sha256 hash is computed from the json string
# this resource will get triggered again anytime the sha256 hash changes
# which should happen anytime a security rule is updated in the NSGs
resource "time_sleep" "nsg_rule_change_propagation" {
  create_duration = "120s"

  triggers = {
    main_nsg_rules = sha256(jsonencode(azurerm_network_security_group.main_nsg.security_rule))
    data_nsg_rules = sha256(jsonencode(azurerm_network_security_group.data_nsg.security_rule))
  }
}
