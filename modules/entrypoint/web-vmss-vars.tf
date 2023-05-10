variable "config_web_folder" {
  type        = string
  description = "Holds the root path for Web folder"
}

variable "jwt_secret" {
  type        = string
  sensitive   = true
  description = "Json Web Token secret."
}

variable "is_small_environment" {
  type = bool
}

variable "asg_web_id" {
  type        = string
  description = "Application security group id for Web tier."
}

variable "pocket_menu_option" {
  type        = string
  description = "Config setting for Pocket Periscope menu file (should be 0, 1, or 2)"
}

variable "sentinel_workspace_name" {
  type        = string
  description = "Name of the workspace for MMA extension to send logs."
}

variable "force_update_tag" {
  type        = string
  description = "md5 content of menu config file to force CSE update"
}

variable "redis_name" {
  type        = string
  description = "Redis private IP address."
}

variable "redis_ssl_port" {
  type        = string
  description = "Redis SSL port."
}

variable "redis_non_ssl_port" {
  type        = string
  description = "Redis non-SSL port."
}

variable "redis_pass" {
  type        = string
  sensitive   = true
  description = "Redis primary access key."
}

variable "storage_account" {
  type        = string
  description = "Name of storage account containing config files"
}

variable "container_name" {
  type        = string
  description = "Name of container in storage account with config files"
}

variable "ssl_url" {
  type        = string
  description = "SSL cert secret URL."
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

variable "web_config_blob" {
  type        = string
  description = "Web VM config script."
}

variable "web_config_url" {
  type        = string
  description = "URL for web VM config script."
}

variable "admin_password" {
  type        = string
  description = "Randomly generated password stored in shared services key vault."
}

variable "time_zone" {
  type        = string
  description = "VM time zone."
}

variable "web_image_size" {
  type        = string
  description = "Sku of web layer VMs."
}

variable "small_web_image_size" {
  type        = string
  description = "Small environment image size"
}

variable "web_image_name" {
  type        = string
  description = "Name of web layer shared image."
}

variable "web_image_version" {
  type        = string
  description = "Version of web layer shared image."
}


variable "web_instance_min" {
  type        = string
  description = "Minimum number of web layer VMs."
}

variable "web_instance_max" {
  type        = string
  description = "Maximum number of web layer VMs."
}

variable "sig_name" {
  type        = string
  description = "Name of shared image gallery."
}

variable "ss_resource_group_name" {
  type        = string
  description = "Shared services resource group name."
}

variable "vmss_subnet_id" {
  type = string
}

variable "mq_private_ip" {
  type = string
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
variable "has_sso_ssl_certificate" {
  type        = bool
  default     = false
  description = "sso_ssl_certificate exit check"
}