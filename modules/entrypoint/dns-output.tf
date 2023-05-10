output "peri_cname_record" {
  value = azurerm_dns_cname_record.peri_cname_record.name
}

output "ws_cname_record" {
  value = azurerm_dns_cname_record.ws_cname_record.name
}

output "mo_cname_record" {
  value = azurerm_dns_cname_record.mo_cname_record.name
}

output "app_gw_public_ip_name" {
  value = var.use_shared_app_gateway ? null : azurerm_public_ip.app_gw_public_ip[0].name
}

output "app_gw_public_ip_id" {
  value = var.use_shared_app_gateway ? null : azurerm_public_ip.app_gw_public_ip[0].id
}
