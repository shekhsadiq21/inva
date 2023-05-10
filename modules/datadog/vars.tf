variable "env" {
  type        = string
  description = "Name of deploment environment."
}

variable "resource_prefix" {
  type = string
}

variable "customer_name" {
  type = string
}

variable "location" {
  type        = string
  description = "main location for this deployment"
}

variable "is_datadog_deployed" {
  type        = bool
  description = "DataDog feature flag."
}

variable "web_vmss_min_instance" {
  type = number
}

variable "appgw_backend_pool_name" {
  type = string
}

variable "appgw_default_backend_http_setting_name" {
  type = string
}

variable "appgw_webservices_backend_http_setting_name" {
  type = string
}

variable "appgw_mobile_backend_http_setting_name" {
  type = string
}

