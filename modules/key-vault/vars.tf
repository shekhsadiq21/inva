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

variable "ss_resource_group_name" {
  type        = string
  description = "Name of shared services resource group."
}

variable "ss_location" {
  type        = string
  description = "Location of shared services resource group."
}

variable "subscription_id" {
  type        = string
  description = "Shared services subscription ID."
}

variable "key_vault_name" {
  type        = string
  description = "Name of key vault in shared services subscription."
}

variable "agw_identity_principal_id" {
  type        = string
  description = "AGW managed identity principal ID."
}

variable "vm_identity_principal_id" {
  type        = string
  description = "VM managed identity principal ID."
}

variable "password_last_changed_date" {
  type        = string
  description = "Date of the last time the passwords had beed rotated"
}