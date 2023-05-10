variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "resource_group_name" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "is_small_environment" {
  type = bool
}

variable "vm_zone" {
  type = string
}

variable "subscription_id" {
  type        = string
  description = "Shared services subscription id."
}

variable "ss_resource_group_name" {
  type        = string
  description = "Shared services resource group name."
}

variable "ss_location" {
  type        = string
  description = "Location of shared services resource group."
}

variable "sig_name" {
  type        = string
  description = "Name of shared image gallery."
}

variable "app_instance_min" {
  type        = string
  description = "Minimum number of app layer VMs."
}

variable "app_instance_max" {
  type        = string
  description = "Maximum number of app layer VMs."
}

variable "app_image_size" {
  type        = string
  description = "Sku of app layer VMs."
}

variable "small_app_image_size" {
  type        = string
  description = "Sku of small app layer VMs."
}

variable "app_image_name" {
  type        = string
  description = "Name of app layer shared image."
}

variable "app_image_version" {
  type        = string
  description = "Version of app layer shared image."
}

variable "mq_image_size" {
  type        = string
  description = "Sku of mq layer VMs."
}

variable "small_mq_image_size" {
  type        = string
  description = "Sku of small mq layer VMs."
}

variable "mq_image_name" {
  type        = string
  description = "Name of mq layer shared image."
}

variable "mq_image_version" {
  type        = string
  description = "Version of mq layer shared image."
}

variable "admin_password" {
  type        = string
  description = "Randomly generated password stored in shared services key vault."
}

variable "time_zone" {
  type        = string
  description = "VM time zone."
}

variable "app_config_blob" {
  type        = string
  description = "App VM config script."
}

variable "app_config_url" {
  type        = string
  description = "URL for app VM config script."
}

variable "sql_server_fqdn" {
  type        = string
  description = "Fully qualified domain name of MSSQL Server instance."
}

variable "sql_server_user" {
  type        = string
  description = "MSSQL Server username."
}

variable "sql_server_pass" {
  type        = string
  description = "MSSQL Server password"
}

variable "db_name" {
  type        = string
  description = "DB name"
}

variable "subject_list" {
  type        = string
  description = "List of Periscope app subjects."
}

variable "DSS2_count" {
  type        = string
  description = "DSS2 count."
}

variable "TRAX_count" {
  type        = string
  description = "Freshtrax count."
}

variable "vm_identity_id" {
  type        = string
  description = "ID of managed identity with reader access to the script container."
}

variable "vm_identity_client_id" {
  type        = string
  description = "Client ID of managed identity with reader access to the script container."
}

variable "domain_account_password" {
  type        = string
  description = "Password for domain account that can join to invafreshds.com"
}

variable "mq_config_blob" {
  type        = string
  description = "mq VM config script."
}

variable "mq_config_url" {
  type        = string
  description = "URL for mq VM config script."
}

variable "storage_account" {
  type        = string
  description = "Name of storage account containing config files"
}

variable "container_name" {
  type        = string
  description = "Name of container in storage account with config files"
}

variable "recipe_manager_storage_account_name" {
  type        = string
  description = "Name of storage account that holds recipe manager images"
}

variable "recipe_manager_container_name" {
  type        = string
  description = "Name of container in storage account that holds recipe manager images"
}

variable "account_key" {
  type        = string
  description = "Account key for storage account with config files"
}

variable "sentinel_workspace_name" {
  type        = string
  description = "Name of the workspace for MMA extension to send logs."
}

variable "asg_mq_id" {
  type        = string
  description = "Application security group id for MQ tier."
}

variable "asg_app_id" {
  type        = string
  description = "Application security group id for App tier."
}

variable "asg_esha_id" {
  type        = string
  description = "Application security group id for Esha tier."
}

variable "is_esha_deployed" {
  type        = bool
  description = "Deploy esha resources for this environment"
}

variable "esha_image_size" {
  type        = string
  description = "Sku of esha layer VMs."
}

variable "small_esha_image_size" {
  type        = string
  description = "Sku of small esha layer VMs."
}

variable "esha_image_name" {
  type        = string
  description = "Name of esha layer shared image."
}

variable "esha_image_version" {
  type        = string
  description = "Version of esha layer shared image."
}

variable "esha_config_url" {
  type        = string
  description = "esha config blob url"
}

variable "esha_config_blob" {
  type        = string
  description = "esha config blob name"
}

variable "launch_darkly_sdk_id" {
  type        = string
  description = "Launch Darkly SDK ID"
}

variable "os_storage_account_type" {
  type        = string
  description = "OS Disk type: Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_LRS and Premium_ZRS"
  default     = "Standard_LRS"
}


variable "enable_accelerated_networking" {
  type        = bool
  description = "Should Accelerated Networking be enabled?"
  default     = false
}

variable "mq_persistent_disk_size" {
  type        = string
  description = "Size of the MQ disk"
  default     = "64"
}
