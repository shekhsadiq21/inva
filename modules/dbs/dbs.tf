resource "azurerm_mssql_database" "db1" {
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags["Tier"],
      sku_name,
      min_capacity,
      max_size_gb,
      zone_redundant,
      auto_pause_delay_in_minutes,
      storage_account_type,
      collation
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "frp-Database"
  })

  count = var.is_prod_db_resource_used ? 0 : 1

  name                        = "sqldb_${var.resource_prefix}_${var.env}_${var.location}_001"
  server_id                   = var.sql_server_id
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  sku_name                    = var.db_sku
  min_capacity                = var.db_min_size
  max_size_gb                 = var.db_max_size
  zone_redundant              = false
  elastic_pool_id             = var.epool_id
}

data "azurerm_subscription" "current" {
}

## We need to use this deprecated implementation of azure sql db because the new azurerm_mssql_database does not currently
## allow to import a bacpac db backup
resource "azurerm_sql_database" "esha" {
  count = var.is_esha_deployed ? 1 : 0

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags["Tier"],
      requested_service_objective_name,
      edition,
      zone_redundant,
      collation
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "esha-Database"
  })

  name                = local.esha_db_name
  resource_group_name = var.resource_group_name
  server_name         = var.sql_server_name
  location            = var.location
  edition             = "GeneralPurpose"
  max_size_bytes      = var.esha_db_max_size

  requested_service_objective_name = var.esha_db_sku_import

  zone_redundant = false

  provisioner "local-exec" {
    command = templatefile("${path.module}/esha-db-provision.ps1", {
      deployment_sub                           = data.azurerm_subscription.current.subscription_id,
      resource_group_name                      = var.resource_group_name,
      resource_prefix                          = var.resource_prefix,
      env                                      = var.env,
      location                                 = var.location,
      sql_server_id                            = var.sql_server_id,
      sql_server_name                          = var.sql_server_name,
      sql_server_fqdn                          = var.sql_server_fqdn,
      esha_db_name                             = local.esha_db_name,
      sql_server_user                          = var.sql_server_user,
      esha_db_core_count                       = var.esha_db_core_count,
      adgroup                                  = local.adgroup,
      ad_db_pass                               = var.ad_db_pass,
      esha_db_backup_storage_account_admin_key = var.esha_db_backup_storage_account_admin_key,
      db_pass                                  = var.db_pass,
      esha_customer_number                     = var.esha_customer_number,
      esha_port_sql_serial_key                 = var.esha_port_sql_serial_key,
      esha_genesis_serial_key                  = var.esha_genesis_serial_key
    })

    interpreter = ["pwsh", "-Command"]
  }
}

resource "azurerm_mssql_database" "provisioned_prod" {
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags["Tier"],
      sku_name,
      min_capacity,
      max_size_gb,
      zone_redundant,
      auto_pause_delay_in_minutes,
      storage_account_type,
      collation,
      elastic_pool_id
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "frp-Database"
  })

  count = var.is_prod_db_resource_used ? 1 : 0

  name        = "sqldb_prod_${var.resource_prefix}_${var.env}_${var.location}_001"
  server_id   = var.sql_server_id
  sku_name    = var.db_sku
  max_size_gb = var.db_max_size
  # if the epool_id is null, this attribute is not used
  elastic_pool_id = var.epool_id
  zone_redundant  = !var.is_small_environment # Zone redudant is only available to premium sql elastic pools
}

resource "azurerm_mssql_database_extended_auditing_policy" "policy1" {
  storage_endpoint                        = var.storage_account_endpoint
  storage_account_access_key              = var.storage_account_access_key
  storage_account_access_key_is_secondary = true
  retention_in_days                       = 6
  database_id                             = var.is_prod_db_resource_used ? azurerm_mssql_database.provisioned_prod[0].id : azurerm_mssql_database.db1[0].id
  #checkov:skip=CKV_AZURE_156:
}

resource "azurerm_mssql_database_extended_auditing_policy" "policy2" {
  count = var.is_esha_deployed ? 1 : 0

  storage_endpoint                        = var.storage_account_endpoint
  storage_account_access_key              = var.storage_account_access_key
  storage_account_access_key_is_secondary = true
  retention_in_days                       = 6
  database_id                             = azurerm_sql_database.esha[0].id
  #checkov:skip=CKV_AZURE_156:
}

locals {
  db_name      = var.is_prod_db_resource_used ? azurerm_mssql_database.provisioned_prod[0].name : azurerm_mssql_database.db1[0].name
  esha_db_name = "sqldb_esha_${var.resource_prefix}_${var.env}_${var.location}_001"
  adgroup      = var.is_prod_db_resource_used ? "Inv-Users-PRD-DB_datareader" : "Inv-Users-UAT-DB_datareader"
  db_id        = var.is_prod_db_resource_used ? azurerm_mssql_database.provisioned_prod[0].id : azurerm_mssql_database.db1[0].id
}

resource "azurerm_monitor_diagnostic_setting" "periscope_db" {
  count                      = var.has_monitoring_diagnostic ? 1 : 0
  name                       = "SendtoLogAnalyticsWorkspace_SharedServices"
  target_resource_id         = local.db_id
  log_analytics_workspace_id = var.shared_log_workspace_id

  log {
    category = "SQLInsights"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AutomaticTuning"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "QueryStoreRuntimeStatistics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "QueryStoreWaitStatistics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "Errors"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DatabaseWaitStatistics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "Timeouts"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "Blocks"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "Deadlocks"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DevOpsOperationsAudit"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "SQLSecurityAuditEvents"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "Basic"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "InstanceAndAppAdvanced"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "WorkloadManagement"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "esha_db" {
  count = var.is_esha_deployed && var.has_monitoring_diagnostic ? 1 : 0

  name                       = "SendtoLogAnalyticsWorkspace_SharedServices"
  target_resource_id         = azurerm_sql_database.esha[0].id
  log_analytics_workspace_id = var.shared_log_workspace_id

  log {
    category = "SQLInsights"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AutomaticTuning"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "QueryStoreRuntimeStatistics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "QueryStoreWaitStatistics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "Errors"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DatabaseWaitStatistics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "Timeouts"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "Blocks"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "Deadlocks"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "DevOpsOperationsAudit"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "SQLSecurityAuditEvents"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "Basic"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "InstanceAndAppAdvanced"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "WorkloadManagement"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}
