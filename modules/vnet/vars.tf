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

variable "resource_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "main_address_space" {
  type = string
}

variable "data_address_space" {
  type = string
}

variable "dns_server" {
  type = list(string)
}

# variable "nwwatcher_rg_name" {
#   type = string
# }

variable "ss_resource_group_name" {
  type        = string
  description = "Name of shared services resource group."
}

variable "ss_vnet_name" {
  type        = string
  description = "Name of shared services vnet."
}

variable "ss_vnet_id" {
  type        = string
  description = "ID of shared services vnet."
}

variable "connect_with_ffrp_analytics_env_flag" {
  type        = bool
  description = "Feature flag for if the periscope environment is to connect to the analytics platform"
}

variable "ffrp_analytics_vnet_name" {
  type        = string
  description = "Name of selected analytics platform's vnet"
}

variable "ffrp_analytics_vnet_id" {
  type        = string
  description = "ID of selected analytics platform's vnet"
}

variable "ffrp_analytics_resource_group_name" {
  type        = string
  description = "Name of selected analytics platform's resource group"
}

variable "gitlab_k8_resource_group_name" {
  type        = string
  description = "Name of selected Gitlab Kubernetes Cluster resource group"
}

variable "gitlab_k8_vnet_name" {
  type        = string
  description = "Name of selected Gitlab Kubernetes virtual network"
}