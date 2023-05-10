resource "azurerm_user_assigned_identity" "vm_blob_access_identity" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags                = var.common_tags
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "vm-identity-${var.resource_prefix}-${var.env}-${var.location}"
}

resource "azurerm_role_assignment" "blob_access" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.vm_blob_access_identity.principal_id
}

resource "azurerm_role_assignment" "artifacts_blob_access" {
  scope                = var.artifact_storage_account_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.vm_blob_access_identity.principal_id
}

resource "azurerm_role_assignment" "recipe_manager_blob_access" {
  scope                = var.recipe_manager_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.vm_blob_access_identity.principal_id
}

resource "azurerm_user_assigned_identity" "agw_vault_access_identity" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags                = var.common_tags
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "agw-identity-${var.resource_prefix}-${var.env}-${var.location}"
}
