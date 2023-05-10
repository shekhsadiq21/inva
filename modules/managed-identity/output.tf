output "vm_identity_id" {
  value = azurerm_user_assigned_identity.vm_blob_access_identity.id
}

output "vm_identity_client_id" {
  value = azurerm_user_assigned_identity.vm_blob_access_identity.client_id
}

output "agw_identity_id" {
  value = azurerm_user_assigned_identity.agw_vault_access_identity.id
}

output "agw_identity_principal_id" {
  value = azurerm_user_assigned_identity.agw_vault_access_identity.principal_id
}

output "vm_identity_principal_id" {
  value = azurerm_user_assigned_identity.vm_blob_access_identity.principal_id
}
