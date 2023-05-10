variable "ss_subscription_id" {
  type        = string
  description = "ID of shared services subscription."
}

variable "ss_resource_group_name" {
  type        = string
  description = "Name of shared services resource group."
}

variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "resource_prefix" {
  type        = string
  description = "Resource prefix for clearer resource names."
}

variable "env" {
  type        = string
  description = "Target deployment environment."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Target deployment location."
}

variable "sql_server_id" {
  type        = string
  description = "SQL Server ID."
}

variable "sql_server_fqdn" {
  type        = string
  description = "SQL Server address."
}

variable "sql_server_name" {
  type        = string
  description = "Name of SQL Server."
}

variable "sql_server_user" {
  type        = string
  description = "SQL Server admin user name."
}

variable "db_pass" {
  type        = string
  sensitive   = true
  description = "SQL Server admin password."
}

variable "db_min_size" {
  type        = number
  description = "Minimum desired size of Periscope DB instance in GBs."
}

variable "db_max_size" {
  type        = number
  description = "Maximum desired size of Periscope DB instance in GBs."
}

variable "db_sku" {
  type        = string
  description = "Desired Periscope DB sku."
}

variable "is_esha_deployed" {
  type        = bool
  description = "Deploy esha resources for this environment"
}

variable "esha_db_max_size" {
  type        = number
  description = "Maximum desired size of Esha DB instance in GBs."
}

variable "esha_db_core_count" {
  type        = string
  description = "Desired Esha DB core count."
}

variable "esha_customer_number" {
  type        = string
  description = "ESHA customer number."
}

variable "esha_db_sku_import" {
  type        = string
  description = "Desired Esha DB sku during import."
}

variable "esha_genesis_serial_key" {
  type        = string
  description = "ESHA Genesis R&D Serial Key."
}

variable "esha_port_sql_serial_key" {
  type        = string
  description = "ESHA Port SQL Serial Key."
}

variable "esha_db_backup_storage_account_admin_key" {
  type        = string
  description = "ESHA db backup storage account admin key."
}

variable "storage_account_endpoint" {
  type        = string
  description = "Storage account endpoint for adding script blob."
}

variable "storage_account_access_key" {
  type        = string
  description = "Storage account access key for adding script blob."
}

variable "is_prod_db_resource_used" {
  type        = bool
  description = "Feature flag."
}

variable "auto_pause_delay_in_minutes" {
  type        = string
  description = "Desired time for db to spin down and save cost"
}

variable "module_manager_tenant_id" {
  type        = string
  description = "Tenant ID used to generate the feature token SQL script in Module Manager."
}

variable "ss_primary_connection_string" {
  type        = string
  description = "Connection string for storage account access."
}

variable "ad_db_pass" {
  type        = string
  description = "Password for domain account from INV-Users-CloudDBAdmin"
}

variable "shared_log_workspace_id" {
  type        = string
  description = "Shared Log Analytics workspace ID target for DBs diagnostic settings"
}

variable "is_small_environment" {
  type = bool
}

variable "epool_id" {
  type = string
}

variable "has_monitoring_diagnostic" {
  type        = bool
  default     = true
  description = "Boolean toggle to send diagnostic logs to azure log services"
}
