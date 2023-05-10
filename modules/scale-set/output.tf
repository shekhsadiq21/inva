# output "web_ss" {
#   value = azurerm_windows_virtual_machine_scale_set.web
# }

# output "secret" {
#   value = data.azurerm_key_vault_secret.kv_secret.value
# }

#  output "mq_private_ip" {
#      value = azurerm_windows_virtual_machine.mq.private_ip_address
#  }

output "app_vmss_name" {
  value = azurerm_windows_virtual_machine_scale_set.app.name
}

output "mq_ip" {
  value = azurerm_network_interface.mq-nic.private_ip_address
}

output "mq_vm_name" {
  value = azurerm_windows_virtual_machine.mq.name
}

output "esha_ip" {
  value = var.is_esha_deployed ? azurerm_windows_virtual_machine.esha[0].private_ip_address : null
}

output "esha_vm_name" {
  value = var.is_esha_deployed ? azurerm_windows_virtual_machine.esha[0].name : null
}

output "app_image_periscope_version" {
  value = data.azurerm_shared_image_version.app.tags.PeriscopeVersion
}

output "mq_image_periscope_version" {
  value = data.azurerm_shared_image_version.mq.tags.PeriscopeVersion
}
