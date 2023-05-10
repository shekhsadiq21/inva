variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "resource_group_name" {
  type = string
}

variable "subscription_id" {
  type        = string
  description = "Shared services subscription ID."
}

variable "ss_resource_group_name" {
  type        = string
  description = "Resource group name for shared services main rg."
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

variable "sql_server_id" {
  type = string
}

variable "sql_server_name" {
  type = string
}

variable "redis_id" {
  type        = string
  description = "Redis server ID."
}

variable "redis_name" {
  type        = string
  description = "Redis server name."
}

variable "main_vnet_id" {
  type        = string
  description = "Main Vnet ID."
}

variable "data_vnet_name" {
  type        = string
  description = "Data vnet name."
}

variable "data_vnet_id" {
  type        = string
  description = "Data vnet ID."
}

variable "data_subnet_id" {
  type        = string
  description = "Subnet id for SQL."
}

variable "redis_subnet_id" {
  type        = string
  description = "Subnet id for Redis"
}

variable "is_small_environment" {
  type        = string
  default     = false
  description = "Does this environment use small image sizes?"
}
