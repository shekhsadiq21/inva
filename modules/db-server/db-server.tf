resource "azurerm_storage_account" "db-storage" {
  count = var.is_small_environment ? 0 : 1
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }

  name                     = "stdb${var.resource_prefix}${var.env}${lower(var.location)}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #checkov:skip=CKV_AZURE_3:enable_https_traffic_only = true
  #checkov:skip=CKV_AZURE_33:Logging enabled for read/write/delete
  #checkov:skip=CKV_AZURE_44:min_tls_version = TLS1_2
  #checkov:skip=CKV_AZURE_35:network_rules { default_action="Deny" }
  #checkov:skip=CKV2_AZURE_18:https://docs.bridgecrew.io/docs/ensure-that-storage-accounts-use-customer-managed-key-for-encryption
  #checkov:skip=CKV2_AZURE_1:https://docs.bridgecrew.io/docs/ensure-storage-for-critical-data-are-encrypted-with-customer-managed-key
  #checkov:skip=CKV_AZURE_59:Ensure that Storage accounts disallow public access
  #checkov:skip=CKV_AZURE_206:Ensure that Storage Accounts use replication
  #checkov:skip=CKV_AZURE_190:Ensure that Storage blobs restrict public access

  tags = merge(var.common_tags, {
    Tier = "frp-Database"
  })
}
#
resource "azurerm_mssql_server" "sqlserver" {
  count = var.is_small_environment ? 0 : 1
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "frp-Database"
  })
  name                          = "sql-${var.resource_prefix}-${var.env}-${lower(var.location)}-001"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = "invauser"
  administrator_login_password  = var.admin_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
  #checkov:skip=CKV_AZURE_24:retention_in_days = <90 or greater>

  azuread_administrator {
    login_username = "INV-Users-CloudDBAdmin"
    object_id      = var.sql_admin_object_id
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "db-sa-role" {
  count                = var.is_small_environment ? 0 : 1
  scope                = azurerm_storage_account.db-storage[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mssql_server.sqlserver[0].identity.0.principal_id
}

resource "azurerm_mssql_server_extended_auditing_policy" "sqlserver-ext-audit-policy" {
  count                                   = var.is_small_environment ? 0 : 1
  server_id                               = azurerm_mssql_server.sqlserver[0].id
  storage_endpoint                        = azurerm_storage_account.db-storage[0].primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.db-storage[0].primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6

  depends_on = [
    azurerm_role_assignment.db-sa-role,
  ]
}

# resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
#   name                = "vnet-rule-${var.resource_prefix}-${var.env}-${var.location}-001"
#   resource_group_name = var.resource_group_name
#   server_name         = azurerm_mssql_server.sqlserver.name
#   subnet_id           = var.vmss_subnet_id
#   # ignore_missing_vnet_service_endpoint = true
# }
