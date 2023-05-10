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

variable "storage_account_id" {
  type        = string
  description = "ID of storage account container that holds powershell config scripts."
}

variable "recipe_manager_storage_account_id" {
  type        = string
  description = "ID of storage account that holds recipe manager images."
}

variable "key_vault_id" {
  type        = string
  description = "Key vault id."
}

variable "artifact_storage_account_id" {
  type = string
}