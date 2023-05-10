locals {
  teams_notification     = var.env == "prd" ? "@teams-datadog-prod" : "@teams-datadog-non-prod"
  pagerduty_notification = var.env == "prd" ? "@pagerduty" : ""
  jwt_body               = "{\"user\":\"ePLUM\", \"password\":\"\", \"clientid\":\"100001\"}"
  formated_customer_name = lower(replace(var.customer_name, "/\\W/", "_"))
}
resource "datadog_monitor" "appgw_periscope_healthy_host_alert" {
  count             = var.is_datadog_deployed ? 1 : 0
  type              = "query alert"
  query             = "max(last_10m):max:azure.network_applicationgateways.healthy_host_count{backendsettingspool:${var.appgw_backend_pool_name}_${var.appgw_webservices_backend_http_setting_name}} < ${var.web_vmss_min_instance}"
  name              = "${var.customer_name} - ${var.env} - Application Gateway - Periscope unhealthy host alert"
  message           = "The number of healthy VMs targeted by the application gateway exposing Periscope UI is below ${var.web_vmss_min_instance}.\nNotify ${local.teams_notification} ${local.pagerduty_notification}"
  tags              = ["prefix:${var.resource_prefix}", "customer:${local.formated_customer_name}", "env:${var.env}", "type:appgw-unhealthy-host"]
  no_data_timeframe = 10
  notify_audit      = false
  notify_no_data    = false
  renotify_interval = 0
  new_host_delay    = 300
  priority          = 2
  evaluation_delay  = 480

  timeout_h          = 0
  escalation_message = ""

  monitor_thresholds {
    critical = var.web_vmss_min_instance
  }

  include_tags        = true
  require_full_window = true
  locked              = true
}
resource "datadog_monitor" "appgw_pocket_periscope_healthy_host_alert" {
  count             = var.is_datadog_deployed ? 1 : 0
  type              = "query alert"
  query             = "max(last_10m):max:azure.network_applicationgateways.healthy_host_count{backendsettingspool:${var.appgw_backend_pool_name}_${var.appgw_mobile_backend_http_setting_name}} < ${var.web_vmss_min_instance}"
  name              = "${var.customer_name} - ${var.env} - Application Gateway - Pocket Periscope unhealthy host alert"
  message           = "The number of healthy VMs targeted by the application gateway exposing Pocket Periscope is below ${var.web_vmss_min_instance}.\nNotify ${local.teams_notification} ${local.pagerduty_notification}"
  tags              = ["prefix:${var.resource_prefix}", "customer:${local.formated_customer_name}", "env:${var.env}", "type:appgw-unhealthy-host"]
  no_data_timeframe = 10
  notify_audit      = false
  notify_no_data    = false
  renotify_interval = 0
  new_host_delay    = 300
  priority          = 2
  evaluation_delay  = 480

  timeout_h          = 0
  escalation_message = ""

  monitor_thresholds {
    critical = var.web_vmss_min_instance
  }

  include_tags        = true
  require_full_window = true
  locked              = true
}
resource "datadog_monitor" "appgw_periscope_ws_healthy_host_alert" {
  count             = var.is_datadog_deployed ? 1 : 0
  type              = "query alert"
  query             = "max(last_10m):max:azure.network_applicationgateways.healthy_host_count{backendsettingspool:${var.appgw_backend_pool_name}_${var.appgw_webservices_backend_http_setting_name}} < ${var.web_vmss_min_instance}"
  name              = "${var.customer_name} - ${var.env} - Application Gateway - Web services unhealthy host alert"
  message           = "The number of healthy VMs targeted by the application gateway exposing Periscope Web services is below ${var.web_vmss_min_instance}.\nNotify ${local.teams_notification} ${local.pagerduty_notification}"
  tags              = ["prefix:${var.resource_prefix}", "customer:${local.formated_customer_name}", "env:${var.env}", "type:appgw-unhealthy-host"]
  no_data_timeframe = 10
  notify_audit      = false
  notify_no_data    = false
  renotify_interval = 0
  new_host_delay    = 300
  priority          = 2
  evaluation_delay  = 480

  timeout_h          = 0
  escalation_message = ""

  monitor_thresholds {
    critical = var.web_vmss_min_instance
  }

  include_tags        = true
  require_full_window = true
  locked              = true
}
