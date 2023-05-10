output "db_name" {
  value = var.is_prod_db_resource_used ? azurerm_mssql_database.provisioned_prod[0].name : azurerm_mssql_database.db1[0].name
}

output "esha_db_name" {
  value = var.is_esha_deployed ? azurerm_sql_database.esha[0].name : ""
}

output "db_id" {
  value = var.is_prod_db_resource_used ? azurerm_mssql_database.provisioned_prod[0].id : azurerm_mssql_database.db1[0].id
}

output "esha_db_id" {
  value = var.is_esha_deployed ? azurerm_sql_database.esha[0].id : ""
}