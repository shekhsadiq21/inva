variable "domain_name_label" {
  type = string
}

variable "dns_zone_name" {
  type        = string
  description = "Name of DNS zone for customer deploments."
}

variable "dns_zone_rg_name" {
  type        = string
  description = "Name of DNS zone resource group for customer deploments."
}