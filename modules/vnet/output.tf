output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "main_vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "data_vnet_name" {
  value = azurerm_virtual_network.data.name
}

output "data_vnet_id" {
  value = azurerm_virtual_network.data.id
}
