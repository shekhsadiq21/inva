data "azurerm_shared_image_version" "web" {
  provider            = azurerm.shared
  name                = var.web_image_version
  image_name          = var.web_image_name
  resource_group_name = var.ss_resource_group_name
  gallery_name        = var.sig_name
}

data "azurerm_log_analytics_workspace" "sentinel-workspace" {
  provider            = azurerm.shared
  name                = var.sentinel_workspace_name
  resource_group_name = var.ss_resource_group_name
}

locals {
  application_gateway_backend_address_pool_ids = var.use_shared_app_gateway ? data.azurerm_storage_table_entity.shared_app_gw_config[0].entity.appgw_backend_pool_id : azurerm_application_gateway.app_gw[0].backend_address_pool.*.id[0]
}

resource "random_string" "web_vmss_suffix" {
  length  = 6
  special = false
  keepers = {
    admin_password                               = var.admin_password
    location                                     = var.location
    application_gateway_backend_address_pool_ids = local.application_gateway_backend_address_pool_ids
    provisioning_script_command                  = <<EOF
powershell.exe -ExecutionPolicy Unrestricted -File ${var.web_config_blob} -MQ_IP `"${var.mq_private_ip}`" -storageaccount `"${var.storage_account}`" -containername `"${var.container_name}`" -ad_pass `"${var.domain_account_password}`" -redis_name `"${var.redis_name}`" -redis_ssl_port `"${var.redis_ssl_port}`" -redis_pass `"${var.redis_pass}`" -jwt_secret `"${var.jwt_secret}`" -ld_sdk_id `"${var.launch_darkly_sdk_id}`" -has_sso_ssl_certificate `"${var.has_sso_ssl_certificate}`" -env `"${var.env}`"
EOF
  }
}

#### web layer scale set
resource "azurerm_windows_virtual_machine_scale_set" "web" {
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags["Tier"],
    ]
  }
  tags = merge(var.common_tags, {
    Tier            = "Web",
    "Image Version" = var.web_image_version
  })
  name                 = "vmss-web-${var.resource_prefix}-${var.env}-${var.location}-${random_string.web_vmss_suffix.result}"
  computer_name_prefix = "${var.resource_prefix}${var.env}web"
  resource_group_name  = var.resource_group_name
  location             = random_string.web_vmss_suffix.keepers.location
  timezone             = var.time_zone
  zone_balance         = var.env == "prd" ? true : false
  zones                = var.env == "prd" ? try([1, 2], null) : null

  sku             = var.is_small_environment ? var.small_web_image_size : var.web_image_size
  instances       = var.web_instance_min
  admin_username  = "invauser"
  admin_password  = random_string.web_vmss_suffix.keepers.admin_password
  source_image_id = data.azurerm_shared_image_version.web.id

  upgrade_mode             = "Automatic"
  enable_automatic_updates = false
  #checkov:skip=CKV_AZURE_97:encryption_at_host_enabled = true
  #checkov:skip=CKV_AZURE_177:Ensure Windows VM enables automatic updates	
  #checkov:skip=CKV_AZURE_179:Ensure VM agent is installed

  identity {
    type         = "UserAssigned"
    identity_ids = [var.vm_identity_id]
  }

  os_disk {
    storage_account_type = var.os_storage_account_type
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "nic-web-${var.resource_prefix}-${var.env}-${var.location}-${random_string.web_vmss_suffix.result}"
    primary                       = true
    enable_accelerated_networking = var.enable_accelerated_networking

    ip_configuration {
      name                                         = "internal"
      primary                                      = true
      subnet_id                                    = var.vmss_subnet_id
      application_gateway_backend_address_pool_ids = [random_string.web_vmss_suffix.keepers.application_gateway_backend_address_pool_ids]
      application_security_group_ids               = [var.asg_web_id]
    }
  }

  provisioner "local-exec" {
    command = templatefile("${path.module}/web-vmss-provision.ps1", {
      virtualMachineScaleSetName = "vmss-web-${var.resource_prefix}-${var.env}-${var.location}-${random_string.web_vmss_suffix.result}"
      resourceGroupName          = var.resource_group_name
      workspaceId                = data.azurerm_log_analytics_workspace.sentinel-workspace.workspace_id
      workspaceKey               = data.azurerm_log_analytics_workspace.sentinel-workspace.primary_shared_key
      sslUrl                     = var.ssl_url
      vmIdentityClientId         = var.vm_identity_client_id
      webConfigBlobUrl           = var.web_config_url
      webConfigCommand           = random_string.web_vmss_suffix.keepers.provisioning_script_command
      webConfigForceUpdateTag    = var.has_sso_ssl_certificate == true ? data.archive_file.web_folder_sso[0].output_sha : data.archive_file.web_folder[0].output_sha
    })
    interpreter = ["pwsh", "-Command"]
  }

  depends_on = [
    azurerm_application_gateway.app_gw[0]
  ]
}

#### web layer scaling rules
resource "azurerm_monitor_autoscale_setting" "web" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Web"
  })
  name                = "web-scale-rules-${var.resource_prefix}-${var.env}-${var.location}-${random_string.web_vmss_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.web.id

  profile {
    name = "ramProfile"

    capacity {
      default = var.web_instance_min
      minimum = var.web_instance_min
      maximum = var.web_instance_max
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.web.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.web.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT2M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}

data "archive_file" "web_folder" {
  count       = var.has_sso_ssl_certificate == false ? 1 : 0
  type        = "zip"
  source_dir  = var.config_web_folder
  output_path = "webconfig.zip"
}

data "archive_file" "web_folder_sso" {
  count       = var.has_sso_ssl_certificate == true ? 1 : 0
  type        = "zip"
  source_dir  = "${var.config_web_folder}-${var.env}"
  output_path = "webconfigsso.zip"
}
