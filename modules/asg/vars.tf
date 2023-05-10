variable "env" {
  type        = string
  description = "Name of deploment environment."
}

variable "resource_prefix" {
  type = string
}

variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}