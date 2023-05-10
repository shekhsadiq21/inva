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

variable "ss_rg" {
  type        = string
  description = "Shared services resource group name."
}

variable "ss_location" {
  type        = string
  description = "Shared services location."
}

variable "sentinel_workspace_name" {
  type        = string
  description = "Name of the Sentinel Log Analytics Workspace in the shared services subscription."
}

variable "shared_workspace_name" {
  type        = string
  description = "Name of the Shared Log Analytics Workspace in the shared services subscription."
}

variable "subscription_id" {
  type        = string
  description = "Shared services subscription ID."
}
