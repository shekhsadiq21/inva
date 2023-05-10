output "vmss_subnet_id" {
  value = azurerm_subnet.vmss_subnet.id
}

output "data_subnet_id" {
  value = azurerm_subnet.data_subnet.id
}

output "redis_subnet_id" {
  value = azurerm_subnet.redis_subnet.id
}
