# To be removed after CI-1537 is done
provider "pagerduty" {
  alias = "test"
  token = var.pagerduty_token
}


resource "random_string" "random" {
  length  = 5
  upper   = false
  special = false
  number  = false
}

module "resource-groups" {
  source = "./modules/resource-groups"

  resource_prefix = var.resource_prefix
  env             = var.env
  location        = var.main_location
  common_tags     = var.common_tags
}

module "asg" {
  source = "./modules/asg"

  resource_prefix     = var.resource_prefix
  env                 = var.env
  location            = var.main_location
  common_tags         = var.common_tags
  resource_group_name = module.resource-groups.main_rg_name
}

module "vnet" {
  source = "./modules/vnet"

  providers = {
    azurerm           = azurerm
    azurerm.shared    = azurerm.shared
    azurerm.analytics = azurerm.analytics
  }

  resource_group_name      = module.resource-groups.main_rg_name
  data_resource_group_name = module.resource-groups.data_rg_name
  resource_prefix          = var.resource_prefix
  env                      = var.env
  location                 = var.main_location
  main_address_space       = var.main_address_space
  data_address_space       = var.data_address_space
  common_tags              = var.common_tags
  dns_server               = var.dns_server
  ss_resource_group_name   = var.ss_resource_group_name
  ss_vnet_name             = var.ss_vnet_name
  ss_vnet_id               = var.ss_vnet_id

  ffrp_analytics_resource_group_name   = lookup(var.ffrp_analytics_resource_group_name_map, var.connect_with_ffrp_analytics_env_name)
  ffrp_analytics_vnet_id               = lookup(var.ffrp_analytics_vnet_id_map, var.connect_with_ffrp_analytics_env_name)
  ffrp_analytics_vnet_name             = lookup(var.ffrp_analytics_vnet_name_map, var.connect_with_ffrp_analytics_env_name)
  connect_with_ffrp_analytics_env_flag = var.connect_with_ffrp_analytics_env_flag

  gitlab_k8_resource_group_name = var.gitlab_k8_resource_group_name
  gitlab_k8_vnet_name           = var.gitlab_k8_vnet_name

}

module "subnet" {
  source = "./modules/subnet"

  resource_group_name         = module.resource-groups.main_rg_name
  data_resource_group_name    = module.resource-groups.data_rg_name
  resource_prefix             = var.resource_prefix
  env                         = var.env
  location                    = var.main_location
  vnet_name                   = module.vnet.vnet_name
  data_vnet_name              = module.vnet.data_vnet_name
  vmss_subnet                 = var.vmss_subnet
  redis_subnet                = var.redis_subnet
  data_subnet                 = var.data_subnet
  common_tags                 = var.common_tags
  dns_server                  = var.dns_server
  authorized_ip_ranges        = var.authorized_ip_ranges
  datadog_synthetic_ip_ranges = var.datadog_synthetic_ip_ranges

  asg_web_id  = module.asg.asg_web_id
  asg_mq_id   = module.asg.asg_mq_id
  asg_app_id  = module.asg.asg_app_id
  asg_esha_id = module.asg.asg_esha_id
}

module "storage-account" {
  source = "./modules/storage-account"

  resource_group_name            = module.resource-groups.main_rg_name
  customer_url_prefix            = var.customer_url_prefix
  resource_prefix                = var.resource_prefix
  env                            = var.env
  location                       = var.main_location
  result                         = random_string.random.result
  common_tags                    = var.common_tags
  pocket_menu_option             = var.pocket_menu_option
  ss_resource_group_name         = var.ss_resource_group_name
  ss_script_storage_account_name = var.ss_script_storage_account_name
  ss_subscription_id             = var.ss_subscription_id

  artifact_storage_account_name   = var.artifact_storage_account_name
  artifact_storage_container_name = var.artifact_storage_container_name

  is_esha_deployed = var.is_esha_deployed

  config_atjobs_folder    = var.config_atjobs_folder
  config_web_folder       = var.config_web_folder
  has_sso_ssl_certificate = var.has_sso_ssl_certificate
}

module "managed-identity" {
  source = "./modules/managed-identity"

  resource_group_name               = module.resource-groups.main_rg_name
  resource_prefix                   = var.resource_prefix
  env                               = var.env
  location                          = var.main_location
  storage_account_id                = module.storage-account.storage_account_id
  recipe_manager_storage_account_id = module.storage-account.recipe_manager_storage_account_id
  common_tags                       = var.common_tags
  key_vault_id                      = module.key-vault.key_vault_id
  artifact_storage_account_id       = var.artifact_storage_account_id
}

module "key-vault" {
  source = "./modules/key-vault"

  resource_prefix        = var.resource_prefix
  resource_group_name    = module.resource-groups.main_rg_name
  env                    = var.env
  location               = var.main_location
  ss_resource_group_name = var.ss_resource_group_name
  ss_location            = var.ss_location
  subscription_id        = var.ss_subscription_id
  key_vault_name         = var.ss_keyvault_name
  common_tags            = var.common_tags
  # agw_identity_client_id    = module.managed-identity.agw_identity_client_id
  agw_identity_principal_id  = module.managed-identity.agw_identity_principal_id
  vm_identity_principal_id   = module.managed-identity.vm_identity_principal_id
  password_last_changed_date = var.password_last_changed_date
}

module "log-analytics-workspace" {
  source = "./modules/log-analytics-workspace"

  resource_prefix         = var.resource_prefix
  resource_group_name     = module.resource-groups.main_rg_name
  location                = var.main_location
  env                     = var.env
  ss_rg                   = var.ss_resource_group_name
  ss_location             = var.ss_location
  sentinel_workspace_name = var.sentinel_workspace_name
  shared_workspace_name   = var.shared_workspace_name
  subscription_id         = var.ss_subscription_id
  common_tags             = var.common_tags
}

module "db-server" {
  source = "./modules/db-server"

  resource_group_name  = module.resource-groups.data_rg_name
  resource_prefix      = var.resource_prefix
  env                  = var.env
  location             = var.main_location
  result               = random_string.random.result
  admin_password       = module.key-vault.sql_password
  main_address_space   = var.main_address_space
  vmss_subnet_id       = module.subnet.vmss_subnet_id
  common_tags          = var.common_tags
  sql_admin_object_id  = var.sql_admin_object_id
  is_small_environment = var.is_small_environment
}

module "dbs" {
  source = "./modules/dbs"

  is_prod_db_resource_used     = var.is_prod_db_resource_used
  ss_subscription_id           = var.ss_subscription_id
  ss_resource_group_name       = var.ss_resource_group_name
  resource_group_name          = module.resource-groups.data_rg_name
  resource_prefix              = var.resource_prefix
  env                          = var.env
  location                     = var.main_location
  sql_server_id                = module.db-server.sql_server_id
  sql_server_fqdn              = module.db-server.sql_server_fqdn
  sql_server_name              = module.db-server.sql_server_name
  sql_server_user              = module.db-server.sql_server_user
  db_pass                      = module.key-vault.sql_password
  storage_account_endpoint     = module.db-server.storage_account_endpoint
  storage_account_access_key   = module.db-server.storage_account_access_key
  db_min_size                  = var.db_min_size
  db_max_size                  = var.db_max_size
  db_sku                       = var.db_sku
  esha_db_max_size             = var.esha_db_max_size
  esha_db_core_count           = var.esha_db_core_count
  esha_db_sku_import           = var.esha_db_sku_import
  common_tags                  = var.common_tags
  auto_pause_delay_in_minutes  = var.auto_pause_delay_in_minutes
  module_manager_tenant_id     = var.module_manager_tenant_id
  ss_primary_connection_string = module.storage-account.ss_primary_connection_string
  ad_db_pass                   = module.key-vault.domain_account_password
  epool_id                     = module.db-server.epool_id

  is_esha_deployed          = var.is_esha_deployed
  has_monitoring_diagnostic = var.has_monitoring_diagnostic

  is_small_environment = var.is_small_environment

  esha_customer_number     = var.esha_customer_number
  esha_genesis_serial_key  = var.esha_genesis_serial_key
  esha_port_sql_serial_key = var.esha_port_sql_serial_key

  esha_db_backup_storage_account_admin_key = module.storage-account.esha_db_backup_storage_account_admin_key

  shared_log_workspace_id = module.log-analytics-workspace.shared_workspace_id
}

# app gateway + web vmss
module "entrypoint" {
  source = "./modules/entrypoint"

  providers = {
    azurerm        = azurerm
    azurerm.shared = azurerm.shared
  }

  # app gw variables
  resource_prefix             = var.resource_prefix
  resource_group_name         = module.resource-groups.main_rg_name
  env                         = var.env
  location                    = var.main_location
  app_gw_subnet               = var.app_gw_subnet
  app_gw_sku                  = var.app_gw_sku
  vnet_name                   = module.vnet.vnet_name
  vnet_id                     = module.vnet.main_vnet_id
  ss_location                 = var.ss_location
  agw_identity_id             = module.managed-identity.agw_identity_id
  ssl_cert_name               = module.key-vault.ssl_cert_name
  ssl_cert_secret_id          = module.key-vault.ssl_cert_secret_id
  log_workspace_id            = module.log-analytics-workspace.sentinel_workspace_id
  second_log_workspace_id     = module.log-analytics-workspace.shared_workspace_id
  common_tags                 = var.common_tags
  authorized_ip_ranges        = var.authorized_ip_ranges
  datadog_synthetic_ip_ranges = var.datadog_synthetic_ip_ranges

  use_shared_app_gateway                        = var.use_shared_app_gateway
  shared_config_management_storage_account_name = var.shared_config_management_storage_account_name
  shared_config_management_table_name           = var.shared_config_management_table_name

  # web vmss variables
  time_zone               = var.time_zone
  vmss_subnet_id          = module.subnet.vmss_subnet_id
  redis_name              = module.redis.redis_name
  redis_ssl_port          = module.redis.redis_ssl_port
  redis_non_ssl_port      = module.redis.redis_non_ssl_port
  redis_pass              = module.redis.redis_pass
  pocket_menu_option      = var.pocket_menu_option
  admin_password          = module.key-vault.vmss_password
  domain_account_password = module.key-vault.domain_account_password

  sig_name             = var.ss_shared_image_gallery_name
  web_instance_min     = var.web_instance_min
  web_instance_max     = var.web_instance_max
  web_image_size       = var.web_image_size
  small_web_image_size = var.small_web_image_size
  web_image_name       = var.web_image_name
  web_image_version    = var.web_image_version

  is_small_environment = var.is_small_environment
  launch_darkly_sdk_id = module.launch-darkly.launch_darkly_environment_client_side_id

  web_config_blob = module.storage-account.web_config_blob
  web_config_url  = module.storage-account.web_config_url

  storage_account               = module.storage-account.storage_account_name
  container_name                = module.storage-account.storage_account_container
  force_update_tag              = var.has_sso_ssl_certificate == false ? module.storage-account.configfileupdatetag : module.storage-account.configfileupdatetagsso
  os_storage_account_type       = var.os_storage_account_type
  enable_accelerated_networking = var.enable_accelerated_networking

  asg_web_id = module.asg.asg_web_id
  jwt_secret = module.key-vault.jwt_secret

  vm_identity_id        = module.managed-identity.vm_identity_id
  vm_identity_client_id = module.managed-identity.vm_identity_client_id

  ssl_url = module.key-vault.eastus_cert_secret_id

  ss_resource_group_name  = var.ss_resource_group_name
  sentinel_workspace_name = var.sentinel_workspace_name
  has_sso_ssl_certificate = var.has_sso_ssl_certificate

  config_web_folder = var.config_web_folder

  mq_private_ip = module.scale-set.mq_ip

  # dns variables
  domain_name_label = var.use_customer_url_prefix ? var.customer_url_prefix : "${var.resource_prefix}-${var.env}"
  dns_zone_name     = var.dns_zone_name
  dns_zone_rg_name  = var.dns_zone_rg_name
}

module "nsg" {
  source = "./modules/nsg"

  resource_group_name         = module.resource-groups.main_rg_name
  data_resource_group_name    = module.resource-groups.data_rg_name
  resource_prefix             = var.resource_prefix
  env                         = var.env
  location                    = var.main_location
  vnet_name                   = module.vnet.vnet_name
  data_vnet_name              = module.vnet.data_vnet_name
  app_gw_subnet               = module.entrypoint.app_gw_subnet_address_space
  vmss_subnet                 = var.vmss_subnet
  redis_subnet                = var.redis_subnet
  data_subnet                 = var.data_subnet
  common_tags                 = var.common_tags
  dns_server                  = var.dns_server
  authorized_ip_ranges        = var.authorized_ip_ranges
  datadog_synthetic_ip_ranges = var.datadog_synthetic_ip_ranges

  asg_web_id  = module.asg.asg_web_id
  asg_mq_id   = module.asg.asg_mq_id
  asg_app_id  = module.asg.asg_app_id
  asg_esha_id = module.asg.asg_esha_id

  vmss_subnet_id  = module.subnet.vmss_subnet_id
  data_subnet_id  = module.subnet.data_subnet_id
  redis_subnet_id = module.subnet.redis_subnet_id

  ffrp_analytics_vnet_address_space    = lookup(var.ffrp_analytics_vnet_address_space_map, var.connect_with_ffrp_analytics_env_name)
  connect_with_ffrp_analytics_env_flag = var.connect_with_ffrp_analytics_env_flag
}

module "private-link" {
  source = "./modules/private-link"

  resource_group_name    = module.resource-groups.data_rg_name
  subscription_id        = var.ss_subscription_id
  ss_resource_group_name = var.ss_resource_group_name
  resource_prefix        = var.resource_prefix
  env                    = var.env
  location               = var.main_location
  sql_server_id          = module.db-server.sql_server_id
  sql_server_name        = module.db-server.sql_server_name
  redis_id               = module.redis.redis_id
  redis_name             = module.redis.redis_name
  main_vnet_id           = module.vnet.main_vnet_id
  data_vnet_name         = module.vnet.data_vnet_name
  data_vnet_id           = module.vnet.data_vnet_id
  data_subnet_id         = module.subnet.data_subnet_id
  redis_subnet_id        = module.subnet.redis_subnet_id
  common_tags            = var.common_tags
  is_small_environment   = var.is_small_environment
}

module "scale-set" {
  source = "./modules/scale-set"

  resource_group_name = module.resource-groups.main_rg_name
  resource_prefix     = var.resource_prefix
  env                 = var.env
  location            = var.main_location
  common_tags         = var.common_tags
  time_zone           = var.time_zone
  subnet_id           = module.subnet.vmss_subnet_id

  subscription_id         = var.ss_subscription_id
  ss_resource_group_name  = var.ss_resource_group_name
  ss_location             = var.ss_location
  sentinel_workspace_name = var.sentinel_workspace_name

  admin_password = module.key-vault.vmss_password

  domain_account_password = module.key-vault.domain_account_password

  sig_name                      = var.ss_shared_image_gallery_name
  app_instance_min              = var.app_instance_min
  app_instance_max              = var.app_instance_max
  app_image_size                = var.app_image_size
  small_app_image_size          = var.small_app_image_size
  app_image_name                = var.app_image_name
  app_image_version             = var.app_image_version
  mq_image_size                 = var.mq_image_size
  small_mq_image_size           = var.small_mq_image_size
  mq_image_name                 = var.mq_image_name
  mq_image_version              = var.mq_image_version
  mq_persistent_disk_size       = var.mq_persistent_disk_size
  esha_image_size               = var.esha_image_size
  small_esha_image_size         = var.small_esha_image_size
  esha_image_name               = var.esha_image_name
  esha_image_version            = var.esha_image_version
  os_storage_account_type       = var.os_storage_account_type
  enable_accelerated_networking = var.enable_accelerated_networking

  is_small_environment = var.is_small_environment

  vm_identity_id        = module.managed-identity.vm_identity_id
  vm_identity_client_id = module.managed-identity.vm_identity_client_id
  app_config_blob       = module.storage-account.app_config_blob
  app_config_url        = module.storage-account.app_config_url
  mq_config_blob        = module.storage-account.mq_config_blob
  mq_config_url         = module.storage-account.mq_config_url
  esha_config_blob      = module.storage-account.esha_config_blob
  esha_config_url       = module.storage-account.esha_config_url
  storage_account       = module.storage-account.storage_account_name
  container_name        = module.storage-account.storage_account_container
  account_key           = module.storage-account.primary_access_key
  sql_server_fqdn       = module.db-server.sql_server_fqdn
  sql_server_user       = module.db-server.sql_server_user
  sql_server_pass       = module.key-vault.sql_password
  db_name               = module.dbs.db_name
  subject_list          = var.subject_list
  DSS2_count            = var.DSS2_count
  TRAX_count            = var.TRAX_count
  vm_zone               = var.vm_zone
  # if/when the key vault holding the Global Sign SSL cert is moved
  # to East US, change key_vault_id below to ssl_vault_id and
  # and eastus_cert_secret_id to ssl_cert_secret_id
  launch_darkly_sdk_id = module.launch-darkly.launch_darkly_environment_client_side_id

  asg_mq_id   = module.asg.asg_mq_id
  asg_app_id  = module.asg.asg_app_id
  asg_esha_id = module.asg.asg_esha_id

  recipe_manager_storage_account_name = module.storage-account.recipe_manager_storage_account_name
  recipe_manager_container_name       = module.storage-account.recipe_manager_container_name

  is_esha_deployed = var.is_esha_deployed

}

module "redis" {
  source = "./modules/redis"

  resource_prefix     = var.resource_prefix
  resource_group_name = module.resource-groups.data_rg_name
  env                 = var.env
  location            = var.main_location
  redis_capacity      = var.redis_capacity
  common_tags         = var.common_tags
  redis_subnet_id     = module.subnet.redis_subnet_id
}

provider "datadog" {
  alias    = "us3"
  api_key  = var.datadog_api_key
  app_key  = var.datadog_app_key
  api_url  = "https://us3.datadoghq.com"
  validate = true
}

module "datadog" {
  source              = "./modules/datadog"
  is_datadog_deployed = var.is_datadog_deployed

  providers = {
    datadog = datadog.us3
  }

  env             = var.env
  resource_prefix = var.resource_prefix
  customer_name   = var.common_tags.Customer
  location        = var.main_location

  web_vmss_min_instance                       = var.web_instance_min
  appgw_backend_pool_name                     = module.entrypoint.appgw_backend_pool_name
  appgw_default_backend_http_setting_name     = module.entrypoint.appgw_default_backend_http_setting_name
  appgw_webservices_backend_http_setting_name = module.entrypoint.appgw_webservices_backend_http_setting_name
  appgw_mobile_backend_http_setting_name      = module.entrypoint.appgw_mobile_backend_http_setting_name

  depends_on = [
    module.entrypoint,
    module.scale-set,
    module.nsg
  ]
}
provider "launchdarkly" {
  access_token = var.launchdarkly_access_token
}
module "launch-darkly" {
  source = "./modules/launch-darkly"
  env    = var.env
}

