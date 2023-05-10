resource "azurerm_virtual_network" "main" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                = "vnet-main-${var.resource_prefix}-${var.env}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.main_address_space]
  dns_servers         = var.dns_server
  #checkov:skip=CKV_AZURE_183:Ensure that VNET uses local DNS addresses	
}

resource "azurerm_virtual_network" "data" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                = "vnet-data-${var.resource_prefix}-${var.env}-${var.location}-001"
  address_space       = [var.data_address_space]
  location            = var.location
  resource_group_name = var.data_resource_group_name
}

resource "azurerm_virtual_network_peering" "main_to_data" {
  name                         = "vnet-peer-m2d-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = azurerm_virtual_network.data.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "data_to_main" {
  name                         = "vnet-peer-d2m-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.data_resource_group_name
  virtual_network_name         = azurerm_virtual_network.data.name
  remote_virtual_network_id    = azurerm_virtual_network.main.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [
    azurerm_virtual_network_peering.main_to_data
  ]
}

###############################
# The following virtunal network peering resources are created using the current service principal like:
# sbx-tf-sp, uat-tf-sp or prod-tf-sp
# to create both vnet peering in the source and remote vnet (which might be in a different subscription),
# the service principal requires the Network Contributor role in the remote vnet
# ex. sbx-tf-sp will need Network Contributor role in vnet-shared-inva-prod-eastus from Inv-Shared-Services subscription
# such permission currently requires to be manually added to the IAM of the remote vnet, through an IT ticket

resource "azurerm_virtual_network_peering" "main_to_adds" {
  name                         = "vnet-peer-adds-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = var.ss_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true
}

resource "azurerm_virtual_network_peering" "adds_to_main" {
  provider                  = azurerm.shared
  name                      = "vnet-peer-adds-to-main-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name       = var.ss_resource_group_name
  virtual_network_name      = var.ss_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.main.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true

  depends_on = [
    azurerm_virtual_network_peering.main_to_adds
  ]
}

resource "azurerm_virtual_network_peering" "data_to_adds" {
  name                         = "vnet-peer-adds-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.data_resource_group_name
  virtual_network_name         = azurerm_virtual_network.data.name
  remote_virtual_network_id    = var.ss_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true
}

resource "azurerm_virtual_network_peering" "adds_to_data" {
  provider                  = azurerm.shared
  name                      = "vnet-peer-adds-to-data-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name       = var.ss_resource_group_name
  virtual_network_name      = var.ss_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.data.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true

  depends_on = [
    azurerm_virtual_network_peering.data_to_adds
  ]
}

// copied and modified from main_to_data and data_to_main

resource "azurerm_virtual_network_peering" "data_to_analytics" {
  name                         = "vnet-peer-data-to-analytics-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.data_resource_group_name
  virtual_network_name         = azurerm_virtual_network.data.name
  remote_virtual_network_id    = var.ffrp_analytics_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  // only create vnet peer if flag is true
  count = var.connect_with_ffrp_analytics_env_flag == true ? 1 : 0

}

resource "azurerm_virtual_network_peering" "analytics_to_data" {
  provider                     = azurerm.analytics
  name                         = "vnet-peer-analytics-to-data-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.ffrp_analytics_resource_group_name
  virtual_network_name         = var.ffrp_analytics_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.data.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  // only create vnet peer if flag is true
  count = var.connect_with_ffrp_analytics_env_flag == true ? 1 : 0

  depends_on = [
    azurerm_virtual_network_peering.data_to_analytics
  ]
}

data "azurerm_virtual_network" "gitlab_k8" {
  provider            = azurerm.shared
  resource_group_name = var.gitlab_k8_resource_group_name
  name                = var.gitlab_k8_vnet_name
}

resource "azurerm_virtual_network_peering" "main_to_gitlab_k8" {
  name                         = "vnet-peer-main-to-gitlab-k8-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = data.azurerm_virtual_network.gitlab_k8.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "gitlab_k8_to_main" {
  provider                     = azurerm.shared
  name                         = "vnet-peer-gitlab-k8-to-main-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.gitlab_k8_resource_group_name
  virtual_network_name         = var.gitlab_k8_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.main.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [
    azurerm_virtual_network_peering.main_to_gitlab_k8
  ]
}

resource "azurerm_virtual_network_peering" "data_to_gitlab_k8" {
  name                         = "vnet-peer-data-to-gitlab-k8-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.data_resource_group_name
  virtual_network_name         = azurerm_virtual_network.data.name
  remote_virtual_network_id    = data.azurerm_virtual_network.gitlab_k8.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}


resource "azurerm_virtual_network_peering" "gitlab_k8_to_data" {
  provider                     = azurerm.shared
  name                         = "vnet-peer-gitlab-k8-to-data-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name          = var.gitlab_k8_resource_group_name
  virtual_network_name         = var.gitlab_k8_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.data.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [
    azurerm_virtual_network_peering.data_to_gitlab_k8
  ]
}