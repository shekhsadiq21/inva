provider "azurerm" {
  features {}
  alias                      = "ss_sub"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  # version         = "2.46.1"
}

resource "random_password" "sql_password" {
  length           = 30
  special          = true
  override_special = "!@"

  keepers = {
    password_last_changed_date = var.password_last_changed_date
  }
  #checkov:skip=CKV_AZURE_189:Ensure that Azure Key Vault disables public network access
}

resource "random_password" "vmss_password" {
  length           = 30
  special          = true
  override_special = "!@"

  keepers = {
    password_last_changed_date = var.password_last_changed_date
  }
  #checkov:skip=CKV_AZURE_189:Ensure that Azure Key Vault disables public network access
}

resource "random_password" "jwt_secret" {
  length           = 30
  special          = true
  override_special = "!@"

  keepers = {
    password_last_changed_date = var.password_last_changed_date
  }


}

# this vault holds the VMSS and SQL passwords generated above
data "azurerm_key_vault" "kv" {
  provider            = azurerm.ss_sub
  name                = var.key_vault_name
  resource_group_name = var.ss_resource_group_name
}

# this is a copy of the GlobalSign cert and is in use by the compute resources
# but will eventually be replaced by the original GS cert if it Gets moved
# into EastUS
data "azurerm_key_vault_certificate" "eastus_cert" {
  provider     = azurerm.ss_sub
  name         = "GSinvafreshSSL"
  key_vault_id = "/subscriptions/4d56129a-2078-4899-8e93-e3fc3ae74e0b/resourceGroups/rg-shared-inv-prod/providers/Microsoft.KeyVault/vaults/sllcertvault"
}

# this vault holds the SSL cert from GlobalSign which is tricky
# to access because the vault is in central canada. it's in use by
# the application gateway
data "azurerm_key_vault" "cert_kv" {
  provider            = azurerm.ss_sub
  name                = "sllcertvault"
  resource_group_name = "rg-shared-inv-prod"
}

data "azurerm_key_vault_certificate" "ssl_cert" {
  provider     = azurerm.ss_sub
  name         = "GSinvafreshSSL"
  key_vault_id = data.azurerm_key_vault.cert_kv.id
}

resource "azurerm_key_vault_secret" "sql_pass" {
  tags = merge(var.common_tags, {
    Tier = "Database"
  })
  provider     = azurerm.ss_sub
  name         = "kv-secret-${var.resource_prefix}-${var.env}-${var.location}-sql"
  value        = random_password.sql_password.result
  key_vault_id = data.azurerm_key_vault.kv.id
  #checkov:skip=CKV_AZURE_41:expiration_date = "2023-12-30T20:00:00Z" or any valid date 
  #checkov:skip=CKV_AZURE_114:content_type = "text/plain" or the valid type
}

resource "azurerm_key_vault_secret" "vmss_pass" {
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  provider     = azurerm.ss_sub
  name         = "kv-secret-${var.resource_prefix}-${var.env}-${var.location}-vmss"
  value        = random_password.vmss_password.result
  key_vault_id = data.azurerm_key_vault.kv.id
  #checkov:skip=CKV_AZURE_41:expiration_date = "2023-12-30T20:00:00Z" or any valid date 
  #checkov:skip=CKV_AZURE_114:content_type = "text/plain" or the valid type
}

resource "azurerm_key_vault_secret" "jwt_secret" {
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  provider     = azurerm.ss_sub
  name         = "kv-secret-${var.resource_prefix}-${var.env}-${var.location}-jwt-secret"
  value        = random_password.jwt_secret.result
  key_vault_id = data.azurerm_key_vault.kv.id
  #checkov:skip=CKV_AZURE_41:expiration_date = "2023-12-30T20:00:00Z" or any valid date 
  #checkov:skip=CKV_AZURE_114:content_type = "text/plain" or the valid type
}

data "azurerm_key_vault_secret" "domain_account_secret" {
  provider     = azurerm.ss_sub
  name         = "kv-secret-inva-${var.ss_location}-domainaccount"
  key_vault_id = data.azurerm_key_vault.kv.id
}
data "azurerm_client_config" "current" {}

# AGW access policy for cert residing in canada central kv
resource "azurerm_key_vault_access_policy" "agw_identity" {
  provider = azurerm.ss_sub

  key_vault_id = data.azurerm_key_vault.cert_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.agw_identity_principal_id

  certificate_permissions = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
}

# VM access policy for cert vault residing in canada central
resource "azurerm_key_vault_access_policy" "vm_identity" {
  provider = azurerm.ss_sub

  key_vault_id = data.azurerm_key_vault.cert_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.vm_identity_principal_id

  certificate_permissions = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
}

# access policy for cert residing in east us kv
resource "azurerm_key_vault_access_policy" "vm_identity_cert" {
  provider = azurerm.ss_sub

  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.vm_identity_principal_id

  certificate_permissions = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
}
