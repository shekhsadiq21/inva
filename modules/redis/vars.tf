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

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache#capacity
variable "redis_capacity" {
  type        = number
  description = "Size of the Redis Cache instance to deploy, valid values are 0, 1, 2, 3, 4, 5, 6"
}

variable "redis_subnet_id" {
  type        = string
  description = "ID of subnet required for Redis cache."
}
