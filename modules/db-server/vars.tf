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

variable "result" {
  type = string
}

variable "admin_password" {
  type        = string
  description = "Password created in key-vault module, stored in shared services key vault."
}

variable "vmss_subnet_id" {
  type        = string
  description = "Data subnet id."
}

variable "main_address_space" {
  type        = string
  description = "Address space of main Vnet for SQL firewall rule."
}

variable "sql_admin_object_id" {
  type        = string
  description = "Object ID for Azure AD User/Group with admin role on sql servers"
}

variable "is_small_environment" {
  type = bool
}