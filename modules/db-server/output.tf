output "storage_account_endpoint" {
  value = var.is_small_environment ? try(data.azurerm_storage_account.small_envs_logging_storage[0].primary_blob_endpoint, null) : azurerm_storage_account.db-storage[0].primary_blob_endpoint
  depends_on = [
    azurerm_storage_account.db-storage[0]
  ]
}

output "storage_account_access_key" {
  value = var.is_small_environment ? try(data.azurerm_storage_account.small_envs_logging_storage[0].primary_access_key, null) : azurerm_storage_account.db-storage[0].primary_access_key
  depends_on = [
    azurerm_storage_account.db-storage[0]
  ]
}

output "sql_server_id" {
  value = var.is_small_environment ? try(data.azurerm_mssql_server.small_envs_sql_server[0].id, null) : azurerm_mssql_server.sqlserver[0].id
  depends_on = [
    azurerm_mssql_server.sqlserver,
    data.azurerm_mssql_server.small_envs_sql_server
  ]
}

output "sql_server_fqdn" {
  value = var.is_small_environment ? try(data.azurerm_mssql_server.small_envs_sql_server[0].fully_qualified_domain_name, null) : azurerm_mssql_server.sqlserver[0].fully_qualified_domain_name
  depends_on = [
    azurerm_mssql_server.sqlserver,
    data.azurerm_mssql_server.small_envs_sql_server
  ]
}

output "sql_server_name" {
  value = var.is_small_environment ? try(data.azurerm_mssql_server.small_envs_sql_server[0].name, null) : azurerm_mssql_server.sqlserver[0].name
  depends_on = [
    azurerm_mssql_server.sqlserver,
    data.azurerm_mssql_server.small_envs_sql_server
  ]
}

output "sql_server_user" {
  value = var.is_small_environment ? try(data.azurerm_mssql_server.small_envs_sql_server[0].administrator_login, null) : azurerm_mssql_server.sqlserver[0].administrator_login
  depends_on = [
    azurerm_mssql_server.sqlserver,
    data.azurerm_mssql_server.small_envs_sql_server
  ]
}

output "epool_id" {
  value = var.is_small_environment ? try(data.azurerm_mssql_elasticpool.small_envs_epool[0].id, null) : null
  depends_on = [
    data.azurerm_mssql_elasticpool.small_envs_epool
  ]
}