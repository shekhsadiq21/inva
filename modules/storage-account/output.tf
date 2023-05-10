output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "primary_access_key" {
  value = azurerm_storage_account.storage_account.primary_access_key
}

output "ss_primary_connection_string" {
  sensitive = true
  value     = data.azurerm_storage_account.shared_services_storage_account.primary_connection_string
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}

output "storage_account_container" {
  value = azurerm_storage_container.script_container.name
}

output "app_config_blob" {
  value = azurerm_storage_blob.app_config.name
}

output "app_config_url" {
  value = azurerm_storage_blob.app_config.url
}

output "web_config_blob" {
  value = azurerm_storage_blob.web_config.name
}

output "web_config_url" {
  value = azurerm_storage_blob.web_config.url
}

output "mq_config_blob" {
  value = azurerm_storage_blob.mq_config.name
}

output "mq_config_url" {
  value = azurerm_storage_blob.mq_config.url
}

output "esha_config_blob" {
  value = var.is_esha_deployed ? azurerm_storage_blob.esha_config[0].name : ""
}

output "esha_config_url" {
  value = var.is_esha_deployed ? azurerm_storage_blob.esha_config[0].url : ""
}

output "configfileupdatetagsso" {
  value = var.has_sso_ssl_certificate == false ? azurerm_storage_blob.web_menu_config[0].content_md5 : ""
}

output "configfileupdatetag" {
  value = var.has_sso_ssl_certificate == true ? azurerm_storage_blob.web_menu_config_sso[0].content_md5 : ""
}

output "recipe_manager_storage_account_id" {
  value = azurerm_storage_account.recipe_manager_storage_account.id
}

output "recipe_manager_storage_account_name" {
  value = azurerm_storage_account.recipe_manager_storage_account.name
}

output "recipe_manager_container_name" {
  value = azurerm_storage_container.recipe_manager_storage_container.name
}

output "esha_db_backup_storage_account_admin_key" {
  value = data.azurerm_storage_account.esha_db_backup.primary_access_key
}
