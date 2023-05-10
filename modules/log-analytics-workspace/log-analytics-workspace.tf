provider "azurerm" {
  features {}
  alias                      = "ss_sub"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
}

data "azurerm_log_analytics_workspace" "sentinel" {
  provider            = azurerm.ss_sub
  name                = var.sentinel_workspace_name
  resource_group_name = var.ss_rg
}

data "azurerm_log_analytics_workspace" "shared" {
  provider            = azurerm.ss_sub
  name                = var.shared_workspace_name
  resource_group_name = var.ss_rg
}
