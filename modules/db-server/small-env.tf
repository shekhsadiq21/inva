data "azurerm_mssql_server" "small_envs_sql_server" {
  count               = var.is_small_environment ? 1 : 0
  name                = "sql-server-small-env-${var.env}-${var.location}"
  resource_group_name = "rg-small-env-${var.env}-${var.location}"
}

data "azurerm_mssql_elasticpool" "small_envs_epool" {
  count               = var.is_small_environment ? 1 : 0
  name                = "sql-epool-small-env-${var.env}-${var.location}"
  resource_group_name = "rg-small-env-${var.env}-${var.location}"
  server_name         = data.azurerm_mssql_server.small_envs_sql_server[0].name
}

data "azurerm_storage_account" "small_envs_logging_storage" {
  count               = var.is_small_environment ? 1 : 0
  name                = "stdbsml${var.env}${lower(var.location)}"
  resource_group_name = "rg-small-env-${var.env}-${var.location}"
}
