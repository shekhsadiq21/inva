terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [azurerm.shared]
    }
  }
}