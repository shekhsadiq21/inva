variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "customer_url_prefix" {
  type        = string
  description = "Customer URL prefix for DNS."
}

variable "resource_group_name" {
  type = string
}

variable "ss_subscription_id" {
  type        = string
  description = "Shared services subscription ID."
}

variable "ss_resource_group_name" {
  type        = string
  description = "Shared services RG name."
}

variable "ss_script_storage_account_name" {
  type        = string
  description = "Name of shared services script storage account."
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

variable "result" {
  type = string
}

variable "pocket_menu_option" {
  type = string
}

variable "is_esha_deployed" {
  type        = bool
  description = "Deploy esha resources for this environment"
}

variable "artifact_storage_account_name" {
  type = string
}

variable "artifact_storage_container_name" {
  type = string
}

variable "config_atjobs_folder" {
  type        = string
  description = "Holds the root path for ATJobs folder"
}

variable "config_web_folder" {
  type        = string
  description = "Holds the root path for Web folder"
}
variable "has_sso_ssl_certificate" {
  type        = bool
  default     = false
  description = "sso_ssl_certificate exit check"
}