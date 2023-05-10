variable "customer_url_prefix" {
  type        = string
  description = "URL friendly customer name."
}

variable "customer_name" {
  type        = string
  description = "Customer name for DNS URL."
}

variable "resource_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "vm_zone" {
  type = string
}

variable "pagerduty_token" {
  type        = string
  description = "PagerDuty Token to call its API"
}


variable "main_location" {
  type    = string
  default = "eastus"
}

# variable "app_gw_name" {
#   type = string
# }

variable "app_gw_sku" {
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

variable "app_gw_subnet" {
  type = string
}

variable "vmss_subnet" {
  type = string
}

variable "ss_resource_group_name" {
  type        = string
  description = "Name of shared services resource group."
}

variable "is_small_environment" {
  type        = string
  default     = false
  description = "Does this environment use small image sizes?"
}

variable "ss_script_storage_account_name" {
  type        = string
  description = "Name of shared services scripts storage account."
}

variable "ss_location" {
  type        = string
  description = "Location of shared services resource group."
}

variable "ss_subscription_id" {
  type        = string
  description = "ID of subscription that contains shared services resource group."
}

variable "ss_keyvault_name" {
  type        = string
  description = "Shared services key vault name."
}

variable "ss_shared_image_gallery_name" {
  type        = string
  description = "Shared services shared image gallery name."
}

variable "app_instance_min" {
  type        = string
  description = "Minimum number of app layer VMs in the scale set."
}

variable "app_instance_max" {
  type        = string
  description = "Maximum number of app layer VMs."
}

variable "app_image_size" {
  type        = string
  description = "Shared services vm image size."
}

variable "small_app_image_size" {
  type        = string
  description = "Small image size"
}

variable "app_image_name" {
  type        = string
  description = "Shared services vm image name."
}

variable "small_app_image_name" {
  type        = string
  description = "Shared services vm image name."
}

variable "app_image_version" {
  type        = string
  description = "Shared services vm image version."
}

variable "mq_image_size" {
  type        = string
  description = "Shared services vm image size."
}

variable "small_mq_image_size" {
  type        = string
  description = "Small image size sku."
}

variable "mq_image_name" {
  type        = string
  description = "Shared services vm image name."
}

variable "small_mq_image_name" {
  type        = string
  description = "Shared services vm image name."
}

variable "mq_image_version" {
  type        = string
  description = "Shared services vm image version."
}

variable "mq_persistent_disk_size" {
  type        = string
  description = "Size of the MQ disk"
  default     = "64"
}

variable "web_instance_min" {
  type        = string
  description = "Minimum number of web layer VMs in the scale set."
}

variable "web_instance_max" {
  type        = string
  description = "Maximum number of web layer VMs."
}

variable "web_image_size" {
  type        = string
  description = "Shared services vm image size."
}

variable "small_web_image_size" {
  type        = string
  description = "Small image vm size."
}
variable "web_image_name" {
  type        = string
  description = "Shared services vm image name."
}

variable "small_web_image_name" {
  type        = string
  description = "Shared services vm image name."
}

variable "web_image_version" {
  type        = string
  description = "Shared services vm image version."
}

variable "data_subnet" {
  type        = string
  description = "Private subnet address space for Data rg dev deploy."
}

variable "redis_subnet" {
  type        = string
  description = "Private subnet address space for Azure Redis cache."
}

variable "datadog_api_key" {
  type        = string
  description = "Api key needed for DataDog."
}

variable "datadog_app_key" {
  type        = string
  description = "App key needed for DataDog."
}

variable "time_zone" {
  type        = string
  description = "Desired time zone for VMs."
}

variable "required_tags" {
  type        = list(string)
  description = "List of required tags."
}

variable "common_tags" {
  type        = map(any)
  description = "Map of common tags for all resources."
}

# needed when this project is pointed at the shared services subscription
# variable "access_key" {
#   type        = string
#   description = "Access key for remote state."
# }

variable "db_min_size" {
  type        = number
  description = "Minimal capacity in gigabytes that database will always have allocated, if not paused. This property is only settable for General Purpose Serverless databases."
}

variable "db_max_size" {
  type        = number
  description = "max size of the database in gigabytes"
}

variable "db_sku" {
  type        = string
  description = "DB sku setting."
}

variable "subject_list" {
  type        = string
  description = "String containing list of Periscope App services."
}

variable "DSS2_count" {
  type        = string
  description = "DSS2 count."
}

variable "TRAX_count" {
  type        = string
  description = "Freshtrax count."
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache#capacity
variable "redis_capacity" {
  type        = number
  description = "Size of the Redis Cache instance to deploy, valid values are 0, 1, 2, 3, 4, 5, 6"
}

variable "ss_vnet_name" {
  type        = string
  description = "Name of shared services vnet."
}

variable "ss_vnet_id" {
  type        = string
  description = "ID of shared services vnet."
}

variable "sentinel_workspace_name" {
  type        = string
  description = "Name of the workspace for MMA extension to send logs."
}

variable "shared_workspace_name" {
  type        = string
  description = "Name of the workspace for Azure Monitor diagnostics to send logs."
}

variable "dns_zone_name" {
  type        = string
  description = "Name of DNS zone for customer deploments."
}

variable "dns_zone_rg_name" {
  type        = string
  description = "Name of DNS zone resource group for customer deploments."
}

variable "authorized_ip_ranges" {
  type        = list(string)
  description = "List of authorized ip ranges for Periscope access from Customer"
}

variable "datadog_synthetic_ip_ranges" {
  type        = list(string)
  description = "List of authorized ip ranges for Periscope access from Datadog"
  default = [
    "3.96.7.126/32", "52.60.189.53/32", "99.79.87.237/32",     # aws:ca-central-1 / AWS canada central
    "3.18.188.104/32", "3.18.197.0/32", "3.18.172.189/32",     # aws:us-east-2 / AWS Ohio
    "54.177.155.33/32", "52.9.13.199/32", "52.9.139.134/32",   # aws:us-west-1 / AWS N. California
    "40.76.107.170/32", "20.62.248.141/32", "20.83.144.189/32" # azure:eastus / Azure Virginia
  ]                                                            # https://ip-ranges.datadoghq.com/ for values
}
variable "pocket_menu_option" {
  type        = string
  description = "Config setting for Pocket Periscope menu file (should be 0, 1, or 2)"
}

variable "auto_pause_delay_in_minutes" {
  type        = string
  description = "Desired time for db to spin down and save cost"
}

variable "module_manager_tenant_id" {
  type        = string
  description = "TenantID used during Module Manager feature token generation."
}

variable "is_datadog_deployed" {
  type        = bool
  default     = true
  description = "Deploy datadog resources for this environment"
}

variable "is_esha_deployed" {
  type        = bool
  description = "Deploy esha resources for this environment"
}

variable "esha_image_size" {
  type        = string
  description = "Sku of esha layer VMs."
}

variable "small_esha_image_size" {
  type        = string
  description = "Sku of esha layer VMs."
}

variable "esha_image_name" {
  type        = string
  description = "Name of esha layer shared image."
}

variable "small_esha_image_name" {
  type        = string
  description = "Name of esha layer shared image."
}

variable "esha_image_version" {
  type        = string
  description = "Version of esha layer shared image."
}

variable "esha_customer_number" {
  type        = string
  description = "ESHA customer bumber."
  default     = ""
}

variable "esha_genesis_serial_key" {
  type        = string
  description = "ESHA Genesis R&D Serial Key."
  default     = ""
}

variable "esha_port_sql_serial_key" {
  type        = string
  description = "ESHA Port SQL Serial Key."
  default     = ""
}

variable "esha_db_max_size" {
  type        = number
  description = "Maximum desired size of Esha DB instance in bytes."
  default     = 5368709120
}

variable "esha_db_core_count" {
  type        = string
  description = "Desired Esha DB core count."
  default     = "2"
}

variable "esha_db_sku_import" {
  type        = string
  description = "Desired Esha DB sku during import."
  default     = "GP_S_Gen5"
}
variable "sql_admin_object_id" {
  type        = string
  description = "Object ID for Azure AD User/Group with admin role on sql servers"
}

variable "artifact_storage_account_name" {
  type = string
}

variable "artifact_storage_container_name" {
  type = string
}

variable "artifact_storage_account_id" {
  type = string
}

variable "is_prod_db_resource_used" {
  type    = bool
  default = false
}

variable "use_customer_url_prefix" {
  type    = bool
  default = false
}

variable "config_atjobs_folder" {
  type        = string
  default     = "./ATJobs"
  description = "Holds the root path for ATJobs folder"
}

variable "config_web_folder" {
  type        = string
  default     = "./Web"
  description = "Holds the root path for Web folder"
}

variable "use_shared_app_gateway" {
  type        = bool
  default     = false
  description = "Flag to enable the usage of a shared application gateway"
}

variable "shared_config_management_storage_account_name" {
  type = string
}

variable "shared_config_management_table_name" {
  type = string
}

variable "ffrp_analytics_resource_group_name_map" {
  type        = map(string)
  description = "Map of analytics platform environment names to the respective analytics platform resource group name"
}

variable "ffrp_analytics_vnet_name_map" {
  type        = map(string)
  description = "Map of analytics environment names to their vnet names"
}

variable "ffrp_analytics_vnet_id_map" {
  type        = map(string)
  description = "Map of analytics environment names to their vnet ids"
}

variable "ffrp_analytics_vnet_address_space_map" {
  type        = map(string)
  description = "Map of analytics environment names to their vnet address spaces"
}

variable "connect_with_ffrp_analytics_env_flag" {
  type        = bool
  default     = false
  description = "Feature flag for if the periscope environment is to connect to the analytics platform"
}

variable "connect_with_ffrp_analytics_env_name" {
  type        = string
  default     = "dev"
  description = "Name of analytics environment, e.g. dev, uat, prod. Used as a key for the *ffrp_analytics_*_map maps"
}

variable "password_last_changed_date" {
  type        = string
  description = "Date of the last time the passwords had beed rotated"
}

variable "gitlab_k8_resource_group_name" {
  type        = string
  description = "Name of selected Gitlab Kubernetes Cluster resource group"
  default     = "rg-gitlab-k8-cluster"
}

variable "gitlab_k8_vnet_name" {
  type        = string
  description = "Name of selected Gitlab Kubernetes virtual network"
  default     = "vnet-gitlab-k8"
}

variable "launchdarkly_access_token" {
  type        = string
  description = "The access code for launch darkly"
}

variable "os_storage_account_type" {
  type        = string
  description = "OS Disk type: Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_LRS and Premium_ZRS"
  default     = "Standard_LRS"
}


variable "enable_accelerated_networking" {
  type        = bool
  description = "Should Accelerated Networking be enabled?"
  default     = false
}

variable "has_monitoring_diagnostic" {
  type        = bool
  default     = true
  description = "Boolean toggle to send diagnostic logs to azure log services"
}

variable "launchdarkly_project_key" {
  type    = string
  default = "default"
}
variable "has_sso_ssl_certificate" {
  type        = bool
  default     = false
  description = "sso_ssl_certificate exit check"
}