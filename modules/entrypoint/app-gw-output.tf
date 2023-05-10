output "appgw_name" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.appgw_name : azurerm_application_gateway.app_gw[0].name
}

output "appgw_backend_pool_id" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.appgw_backend_pool_id : azurerm_application_gateway.app_gw[0].backend_address_pool.*.id[0]
}

output "appgw_backend_pool_name" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.appgw_backend_pool_name : azurerm_application_gateway.app_gw[0].backend_address_pool.*.id[0]
}

output "appgw_default_backend_http_setting_name" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.appgw_default_http_settings_name : local.http_setting_name
}

output "appgw_webservices_backend_http_setting_name" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.appgw_webservices_http_settings_name : "${local.http_setting_name}-ws"
}

output "appgw_mobile_backend_http_setting_name" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.appgw_mobile_http_settings_name : "${local.http_setting_name}-mo"
}

output "app_gw_subnet_name" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.subnet_name : azurerm_subnet.app_gw_subnet[0].name
}

output "app_gw_subnet_id" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.subnet_id : azurerm_subnet.app_gw_subnet[0].id
}

output "app_gw_subnet_address_space" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.subnet_address_space : azurerm_subnet.app_gw_subnet[0].address_prefixes[0]
}

output "app_gw_rg_name" {
  value = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.resource_group_name : azurerm_application_gateway.app_gw[0].resource_group_name
}