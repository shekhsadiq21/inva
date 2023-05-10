provider "azurerm" {
  features {}
  alias                      = "ss"
  subscription_id            = var.ss_subscription_id
  skip_provider_registration = true
}

locals {
  menu_file_select   = { "0" = "PocketPeriScopeMenus.txt", "1" = "PocketTraceabilityMenus.txt", "2" = "PocketCutTestMenus.txt" }
  web_php_config     = ["ConfigUI.php", "ConfigMo.php", "ConfigTS.php"]
  web_php_config_sso = ["ConfigUI.php", "ConfigMo.php", "ConfigTS.php", "ConfigLarry.txt", "sso.cer"]
}

data "azurerm_storage_account" "shared_services_storage_account" {
  provider            = azurerm.ss
  name                = var.ss_script_storage_account_name
  resource_group_name = var.ss_resource_group_name
}

data "azurerm_storage_account" "esha_db_backup" {
  provider            = azurerm.ss
  name                = "eshabackupinvaprodeastus"
  resource_group_name = var.ss_resource_group_name
}


resource "azurerm_storage_account" "storage_account" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                     = "stag${var.resource_prefix}${var.env}${lower(var.location)}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #checkov:skip=CKV_AZURE_3:enable_https_traffic_only = true
  #checkov:skip=CKV_AZURE_33:Logging enabled for read/write/delete
  #checkov:skip=CKV_AZURE_44:min_tls_version = TLS1_2
  #checkov:skip=CKV_AZURE_35:network_rules { default_action="Deny" }
  #checkov:skip=CKV2_AZURE_18:https://docs.bridgecrew.io/docs/ensure-that-storage-accounts-use-customer-managed-key-for-encryption
  #checkov:skip=CKV2_AZURE_8:container_access_type = "private"
  #checkov:skip=CKV2_AZURE_1:https://docs.bridgecrew.io/docs/ensure-storage-for-critical-data-are-encrypted-with-customer-managed-key
  #checkov:skip=CKV_AZURE_59:Ensure that Storage accounts disallow public access
  #checkov:skip=CKV_AZURE_206:Ensure that Storage Accounts use replication
  #checkov:skip=CKV_AZURE_190:Ensure that Storage blobs restrict public access
}

resource "azurerm_storage_container" "script_container" {
  name                 = "${var.resource_prefix}-scripts"
  storage_account_name = azurerm_storage_account.storage_account.name
  #checkov:skip=CKV2_AZURE_21:https://docs.bridgecrew.io/docs/ensure-storage-logging-is-enabled-for-blob-service-for-read-requests
}

resource "azurerm_storage_blob" "app_config" {
  name                   = "app-vm-config.ps1"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source                 = "${path.module}/app-vm-config.ps1"
  content_md5            = filemd5("${path.module}/app-vm-config.ps1")
}

resource "azurerm_storage_blob" "web_config" {

  lifecycle {
    create_before_destroy = false
  }
  name                   = "web-vm-config.ps1"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source_content = templatefile("${path.module}/web-vm-config.ps1", {
    artifact_storage_account_name   = var.artifact_storage_account_name,
    artifact_storage_container_name = var.artifact_storage_container_name,
    customer_url_prefix             = var.customer_url_prefix == "" ? "${var.resource_prefix}-${var.env}" : var.customer_url_prefix
    pocket_menu_option_file         = local.menu_file_select[var.pocket_menu_option]
  })
}

resource "azurerm_storage_blob" "mq_config" {
  name                   = "mq-vm-config.ps1"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source                 = "${path.module}/mq-vm-config.ps1"
  content_md5            = filemd5("${path.module}/mq-vm-config.ps1")
}

resource "azurerm_storage_blob" "web_menu_config" {
  count                  = var.has_sso_ssl_certificate == false ? 1 : 0
  name                   = local.menu_file_select[var.pocket_menu_option]
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source                 = "${var.config_web_folder}/${local.menu_file_select[var.pocket_menu_option]}"
  content_md5            = filemd5("${var.config_web_folder}/${local.menu_file_select[var.pocket_menu_option]}") #Watch out, this is case sensitive on the Linux build agent
}
resource "azurerm_storage_blob" "web_menu_config_sso" {
  count                  = var.has_sso_ssl_certificate == true ? 1 : 0
  name                   = local.menu_file_select[var.pocket_menu_option]
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source                 = "${var.config_web_folder}-${var.env}/${local.menu_file_select[var.pocket_menu_option]}"
  content_md5            = filemd5("${var.config_web_folder}-${var.env}/${local.menu_file_select[var.pocket_menu_option]}") #Watch out, this is case sensitive on the Linux build agent
}

resource "azurerm_storage_blob" "mq_AT_job_config" {
  for_each = fileset("${path.cwd}/${var.config_atjobs_folder}/", "**")

  name                   = "ATJobs/${each.value}"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source                 = "${path.cwd}/${var.config_atjobs_folder}/${each.value}"
  content_md5            = filemd5("${path.cwd}/${var.config_atjobs_folder}/${each.value}")
}

resource "azurerm_storage_blob" "web_php_config" {
  for_each               = var.has_sso_ssl_certificate == false ? local.web_php_config : toset([])
  name                   = "Web/${each.value}"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source                 = "${var.config_web_folder}/${each.value}"
  content_md5            = filemd5("${var.config_web_folder}/${each.value}") #Watch out, this is case sensitive on the Linux build agent
}

resource "azurerm_storage_blob" "web_php_config_sso" {
  for_each               = var.has_sso_ssl_certificate == true ? local.web_php_config_sso : toset([])
  name                   = "Web-${var.env}/${each.value}"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source                 = "${var.config_web_folder}-${var.env}/${each.value}"
  content_md5            = filemd5("${var.config_web_folder}-${var.env}/${each.value}") #Watch out, this is case sensitive on the Linux build agent
}


resource "azurerm_storage_account" "recipe_manager_storage_account" {
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                            = "recipemngr${var.resource_prefix}${var.env}${lower(substr(var.location, 0, 7))}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true
  #checkov:skip=CKV_AZURE_3:enable_https_traffic_only = true
  #checkov:skip=CKV_AZURE_33:Logging enabled for read/write/delete
  #checkov:skip=CKV_AZURE_44:min_tls_version = TLS1_2
  #checkov:skip=CKV_AZURE_35:network_rules { default_action="Deny" }
  #checkov:skip=CKV2_AZURE_18:https://docs.bridgecrew.io/docs/ensure-that-storage-accounts-use-customer-managed-key-for-encryption
  #checkov:skip=CKV2_AZURE_8:container_access_type = "private"
  #checkov:skip=CKV2_AZURE_1:https://docs.bridgecrew.io/docs/ensure-storage-for-critical-data-are-encrypted-with-customer-managed-key
  #checkov:skip=CKV_AZURE_59:Ensure that Storage accounts disallow public access
  #checkov:skip=CKV_AZURE_206:Ensure that Storage Accounts use replication
  #checkov:skip=CKV_AZURE_190:Ensure that Storage blobs restrict public access

}

resource "azurerm_storage_container" "recipe_manager_storage_container" {
  name                  = "recipe-manager"
  storage_account_name  = azurerm_storage_account.recipe_manager_storage_account.name
  container_access_type = "blob"
  #checkov:skip=CKV2_AZURE_21:https://docs.bridgecrew.io/docs/ensure-storage-logging-is-enabled-for-blob-service-for-read-requests
  #checkov:skip=CKV_AZURE_34:container_access_type = "private"
}

resource "azurerm_storage_blob" "esha_config" {
  count                  = var.is_esha_deployed ? 1 : 0
  name                   = "esha-vm-config.ps1"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.script_container.name
  type                   = "Block"
  source                 = "${path.module}/esha-vm-config.ps1"
  content_md5            = filemd5("${path.module}/esha-vm-config.ps1")
}
