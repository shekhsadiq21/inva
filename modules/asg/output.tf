output "asg_web_id" {
  value = azurerm_application_security_group.asg_web.id
}

output "asg_mq_id" {
  value = azurerm_application_security_group.asg_mq.id
}

output "asg_app_id" {
  value = azurerm_application_security_group.asg_app.id
}

output "asg_esha_id" {
  value = azurerm_application_security_group.asg_esha.id
}