output "web_vmss_name" {
  value = azurerm_windows_virtual_machine_scale_set.web.name
}

output "web_image_periscope_version" {
  value = data.azurerm_shared_image_version.web.tags.PeriscopeVersion
}