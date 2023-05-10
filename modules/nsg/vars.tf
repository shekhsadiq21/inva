variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "resource_group_name" {
  type = string
}

variable "data_resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "data_vnet_name" {
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

variable "app_gw_subnet" {
  type = string
}

variable "vmss_subnet" {
  type = string
}

variable "data_subnet" {
  type        = string
  description = "Subnet address space for db resources."
}

variable "redis_subnet" {
  type        = string
  description = "Subnet address space for Azure Redis cache."
}

variable "dns_server" {
  type        = list(string)
  description = "List of invafreshds.com DNS servers"
}

variable "authorized_ip_ranges" {
  type        = list(string)
  description = "List of authorized ip ranges for Periscope access from Customer"
}

variable "datadog_synthetic_ip_ranges" {
  type        = list(string)
  description = "List of authorized ip ranges for Periscope access from Datadog"
}

variable "asg_web_id" {
  type        = string
  description = "Application security group id for Web tier."
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
  description = "Application security group id for ESHA tier."
}

variable "vmss_subnet_id" {
  type        = string
  description = "VMs/VM scale sets subnet ID"
}

variable "data_subnet_id" {
  type        = string
  description = "Data subnet ID"
}

variable "redis_subnet_id" {
  type        = string
  description = "Redis subnet ID"
}

variable "ffrp_analytics_vnet_address_space" {
  type        = string
  description = "Address space of vnet for selected analytics platform"
}

variable "connect_with_ffrp_analytics_env_flag" {
  type        = bool
  description = "Feature flag for if the periscope environment is to connect to the analytics platform"
}