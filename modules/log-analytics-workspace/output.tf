output "sentinel_workspace_name" {
  value = data.azurerm_log_analytics_workspace.sentinel.name
}

output "sentinel_workspace_id" {
  value = data.azurerm_log_analytics_workspace.sentinel.id
}

output "shared_workspace_name" {
  value = data.azurerm_log_analytics_workspace.shared.name
}

output "shared_workspace_id" {
  value = data.azurerm_log_analytics_workspace.shared.id
}
