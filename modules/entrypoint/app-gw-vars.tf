variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "resource_prefix" {
  type        = string
  description = "Resource prefix."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "env" {
  type        = string
  description = "Chosen deployment environment."
}

variable "location" {
  type        = string
  description = "Azure location."
}

variable "app_gw_subnet" {
  type = string
}

variable "app_gw_sku" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "ss_location" {
  type        = string
  description = "Shared services location."
}

variable "log_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}

variable "second_log_workspace_id" {
  type        = string
  description = "Second log Analytics Workspace ID"
}

variable "ssl_cert_name" {
  type        = string
  description = "SSL cert name."
}

variable "ssl_cert_secret_id" {
  type        = string
  description = "SSL cert secret id."
}

variable "agw_identity_id" {
  type        = string
  description = "Managed identity to allow key vault access for certificate."
}

variable "authorized_ip_ranges" {
  type        = list(string)
  description = "Authorized ip ranges from Customer"
}

variable "datadog_synthetic_ip_ranges" {
  type        = list(string)
  description = "List of authorized ip ranges for Periscope access from Datadog"
}

variable "use_shared_app_gateway" {
  type        = bool
  default     = false
  description = "Flag to enable the usage of a shared application gateway"
}

variable "shared_config_management_storage_account_name" {
  type = string
}

variable "shared_config_management_table_name" {
  type = string
}