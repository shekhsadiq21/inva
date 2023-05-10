resource "azurerm_resource_group" "main_rg" {
  name     = "rg-main-${var.resource_prefix}-${var.env}-${var.location}"
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_resource_group" "data_rg" {
  name     = "rg-data-${var.resource_prefix}-${var.env}-${var.location}"
  location = var.location
  tags     = var.common_tags
}
