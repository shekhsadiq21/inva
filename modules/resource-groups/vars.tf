variable "common_tags" {
  type        = map(any)
  description = "Map of common tags."
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
