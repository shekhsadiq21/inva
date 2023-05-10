resource "azurerm_storage_table_entity" "config_management_database" {
  provider = azurerm.shared

  storage_account_name = var.shared_config_management_storage_account_name
  table_name           = var.shared_config_management_table_name

  partition_key = "periscope-${var.resource_prefix}-${var.env}"
  row_key       = "database"

  entity = {
    azure_sql_server_name             = module.db-server.sql_server_name
    azure_sql_server_address          = module.db-server.sql_server_fqdn
    azure_sql_server_id               = module.db-server.sql_server_id
    azure_sql_periscope_database_name = module.dbs.db_name
    azure_sql_periscope_database_id   = module.dbs.db_id
    azure_sql_esha_database_name      = module.dbs.esha_db_name
    azure_sql_esha_database_id        = module.dbs.esha_db_id
  }
}

resource "azurerm_storage_table_entity" "config_management_keyvault" {
  provider = azurerm.shared

  storage_account_name = var.shared_config_management_storage_account_name
  table_name           = var.shared_config_management_table_name

  partition_key = "periscope-${var.resource_prefix}-${var.env}"
  row_key       = "keyvault"

  entity = {
    azure_keyvault_uri                      = module.key-vault.key_vault_uri
    azure_keyvault_name                     = module.key-vault.key_vault_name
    azure_keyvault_id                       = module.key-vault.key_vault_id
    azure_keyvault_vm_password_secret_name  = module.key-vault.vmss_password_secret_name
    azure_keyvault_sql_password_secret_name = module.key-vault.sql_password_secret_name
    azure_keyvault_jwt_secret_name          = module.key-vault.jwt_secret_name
  }
}

output "main_address_space" {
  value = var.main_address_space
}

output "data_address_space" {
  value = var.data_address_space
}

output "main_rg_name" {
  value = module.resource-groups.main_rg_name
}

output "data_rg_name" {
  value = module.resource-groups.data_rg_name
}

output "app_vmss_name" {
  value = module.scale-set.app_vmss_name
}

output "web_vmss_name" {
  value = module.entrypoint.web_vmss_name
}

output "mq_vm_name" {
  value = module.scale-set.mq_vm_name
}

output "periscope_vm_image_version" {
  value = var.app_image_version
}

output "resource_prefix" {
  value = var.resource_prefix
}

output "customer_name" {
  value = var.customer_name
}

output "ws_hostname" {
  value = "https://${module.entrypoint.ws_cname_record}.invafresh.com"
}

output "mobile_URL" {
  value = "https://${module.entrypoint.mo_cname_record}.invafresh.com"
}

output "periscope_URL" {
  value = "https://${module.entrypoint.peri_cname_record}.invafresh.com"
}

#output "datadog_dashboard_url" {
# value = module.datadog.datadog_dashboard_url
#}

output "mq_ip" {
  value = module.scale-set.mq_ip
}

output "env" {
  value = var.env
}

output "sql_server_name" {
  value = module.db-server.sql_server_name
}

output "sql_server_fqdn" {
  value = module.db-server.sql_server_fqdn
}

output "db_name" {
  value = module.dbs.db_name
}

output "esha_db_name" {
  value = module.dbs.esha_db_name
}

output "authorized_ip_ranges" {
  value = var.authorized_ip_ranges
}

output "location" {
  value = var.main_location
}

output "vm_time_zone" {
  value = var.time_zone
}

output "periscope_artifact_version" {
  value = module.scale-set.app_image_periscope_version
}

output "is_esha_deployed" {
  value = var.is_esha_deployed
}

output "esha_ip" {
  value = var.is_esha_deployed ? module.scale-set.esha_ip : "Not deployed"
}

output "esha_vm_name" {
  value = var.is_esha_deployed ? module.scale-set.esha_vm_name : "Not deployed"
}

output "is_small_environment" {
  value = var.is_small_environment
}
output "small_app_image_size" {
  value = var.small_app_image_size
}

output "small_mq_image_size" {
  value = var.small_mq_image_size
}

output "small_mq_image_name" {
  value = var.small_mq_image_name
}

output "small_web_image_name" {
  value = var.small_web_image_name
}

output "appgw_name" {
  value = module.entrypoint.appgw_name
}

output "app_gw_rg_name" {
  value = module.entrypoint.app_gw_rg_name
}