output "key_vault_id" {
  value = data.azurerm_key_vault.kv.id
}

output "key_vault_name" {
  value = data.azurerm_key_vault.kv.name
}

output "key_vault_uri" {
  value = data.azurerm_key_vault.kv.vault_uri
}

output "sql_password" {
  value     = azurerm_key_vault_secret.sql_pass.value
  sensitive = true
}

output "sql_password_secret_name" {
  value = azurerm_key_vault_secret.sql_pass.name
}

output "vmss_password" {
  value     = azurerm_key_vault_secret.vmss_pass.value
  sensitive = true
}

output "vmss_password_secret_name" {
  value = azurerm_key_vault_secret.vmss_pass.name
}

output "jwt_secret" {
  value     = azurerm_key_vault_secret.jwt_secret.value
  sensitive = true
}

output "jwt_secret_name" {
  value = azurerm_key_vault_secret.jwt_secret.name
}

output "ssl_cert_name" {
  value = data.azurerm_key_vault_certificate.ssl_cert.name
  # sensitive = true
}

output "eastus_cert_secret_id" {
  value = data.azurerm_key_vault_certificate.eastus_cert.secret_id
}

output "ssl_cert_secret_id" {
  value = data.azurerm_key_vault_certificate.ssl_cert.secret_id
  # sensitive = true
}

output "ssl_vault_id" {
  value = data.azurerm_key_vault.cert_kv.id
}

output "domain_account_password" {
  value = data.azurerm_key_vault_secret.domain_account_secret.value
}
