locals {
  esha_ip = var.is_esha_deployed ? azurerm_network_interface.esha-nic[0].private_ip_address : "DISABLED"
}

provider "azurerm" {
  features {}
  alias                      = "ss"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
}

data "azurerm_shared_image_version" "app" {
  provider            = azurerm.ss
  name                = var.app_image_version
  image_name          = var.app_image_name
  resource_group_name = var.ss_resource_group_name
  gallery_name        = var.sig_name
}

data "azurerm_shared_image_version" "mq" {
  provider            = azurerm.ss
  name                = var.mq_image_version
  image_name          = var.mq_image_name
  resource_group_name = var.ss_resource_group_name
  gallery_name        = var.sig_name
}

data "azurerm_shared_image_version" "esha" {
  provider            = azurerm.ss
  name                = var.esha_image_version
  image_name          = var.esha_image_name
  resource_group_name = var.ss_resource_group_name
  gallery_name        = var.sig_name
}

data "azurerm_log_analytics_workspace" "sentinel-workspace" {
  provider            = azurerm.ss
  name                = var.sentinel_workspace_name
  resource_group_name = var.ss_resource_group_name
}

resource "azurerm_network_interface" "mq-nic" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "MQ"
  })
  name                          = "nic-mq-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "mqpersistent" {
  name                 = "${var.resource_prefix}-${var.env}-mqpersistent"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.mq_persistent_disk_size
  #checkov:skip=CKV_AZURE_93:disk_encryption_set_id = "" example "koko"
  zone = try(var.vm_zone, null)

  tags = merge(var.common_tags, {
    Tier = "MQ"
  })
}

resource "azurerm_virtual_machine_data_disk_attachment" "mq" {
  managed_disk_id    = azurerm_managed_disk.mqpersistent.id
  virtual_machine_id = azurerm_windows_virtual_machine.mq.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_windows_virtual_machine" "mq" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier            = "MQ",
    "Image Version" = var.mq_image_version
  })
  name                = "vm-mq-${var.resource_prefix}-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
  timezone            = var.time_zone

  zone = try(var.vm_zone, null)

  size            = var.is_small_environment ? var.small_mq_image_size : var.mq_image_size
  admin_username  = "invauser"
  admin_password  = var.admin_password
  source_image_id = data.azurerm_shared_image_version.mq.id
  #checkov:skip=CKV_AZURE_177:Ensure Windows VM enables automatic updates
  enable_automatic_updates = false
  patch_mode               = "Manual"
  provision_vm_agent       = true
  #checkov:skip=CKV_AZURE_50:We will always skip this. This the check `Ensure Virtual Machine Extensions are not Installed`
  #checkov:skip=CKV_AZURE_97:encryption_at_host_enabled = true
  #checkov:skip=CKV_AZURE_151:Ensure Windows VM enables encryption

  network_interface_ids = [
    azurerm_network_interface.mq-nic.id,
  ]

  os_disk {
    storage_account_type = var.os_storage_account_type
    caching              = "ReadWrite"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.vm_identity_id]
  }
}

resource "azurerm_network_interface_application_security_group_association" "nic_asg_mq_association" {
  network_interface_id          = azurerm_network_interface.mq-nic.id
  application_security_group_id = var.asg_mq_id
}

resource "azurerm_virtual_machine_extension" "mq_config" {
  name                       = "mq_config"
  virtual_machine_id         = azurerm_windows_virtual_machine.mq.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  tags = merge(var.common_tags, {
    Tier = "MQ"
  })

  protected_settings = <<PROTECTED_SETTINGS
        {
          "fileUris": ["${var.mq_config_url}"],
          "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File ${var.mq_config_blob} -mq_ip \"${azurerm_windows_virtual_machine.mq.private_ip_address}\" -storageaccount \"${var.storage_account}\" -containername \"${var.container_name}\" -ad_pass \"${var.domain_account_password}\"",
          "managedIdentity": {"clientId": "${var.vm_identity_client_id}"}
        }
  PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.mq,
    azurerm_virtual_machine_extension.mq_sentinel_log
  ]
}

resource "azurerm_virtual_machine_extension" "mq_sentinel_log" {
  name                 = "mq-MMAgent"
  virtual_machine_id   = azurerm_windows_virtual_machine.mq.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  tags = merge(var.common_tags, {
    Tier = "MQ"
  })

  settings = <<SETTINGS
        {
          "workspaceId": "${data.azurerm_log_analytics_workspace.sentinel-workspace.workspace_id}"
        }
        SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${data.azurerm_log_analytics_workspace.sentinel-workspace.primary_shared_key}"
        }
        PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.mq
  ]
}

#### app layer scale set
resource "random_string" "app_vmss_suffix" {
  length  = 6
  special = false
  keepers = {
    admin_password = var.admin_password
    location       = var.location

    provisioning_script_command = <<EOF
powershell.exe -ExecutionPolicy Unrestricted -File ${var.app_config_blob} -sql_server_fqdn `"${var.sql_server_fqdn}`" -sql_server_pass `"${var.sql_server_pass}`" -db_name `"${var.db_name}`" -mq_ip `"${azurerm_network_interface.mq-nic.private_ip_address}`" -subject_list `"${var.subject_list}`" -DSS2_count ${var.DSS2_count} -TRAX_count ${var.TRAX_count}  -ad_pass `"${var.domain_account_password}`" -recipemngrstorageaccount `"${var.recipe_manager_storage_account_name}`" -recipemngrcontainername `"${var.recipe_manager_container_name}`" -esha_ip `"${local.esha_ip}`"
EOF
  }
}

resource "azurerm_windows_virtual_machine_scale_set" "app" {
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags["Tier"],
    ]
  }
  tags = merge(var.common_tags, {
    Tier            = "App",
    "Image Version" = var.app_image_version
  })
  name                 = "vmss-app-${var.resource_prefix}-${var.env}-${var.location}-${random_string.app_vmss_suffix.result}"
  computer_name_prefix = "${var.resource_prefix}${var.env}app"
  resource_group_name  = var.resource_group_name
  location             = random_string.app_vmss_suffix.keepers.location
  timezone             = var.time_zone
  zones                = var.env == "prd" ? [1, 2] : null
  zone_balance         = var.env == "prd" ? true : false

  sku             = var.is_small_environment ? var.small_app_image_size : var.app_image_size
  instances       = var.app_instance_min
  admin_username  = "invauser"
  admin_password  = random_string.app_vmss_suffix.keepers.admin_password
  source_image_id = data.azurerm_shared_image_version.app.id

  upgrade_mode             = "Automatic"
  enable_automatic_updates = false
  #checkov:skip=CKV_AZURE_97:encryption_at_host_enabled = true
  #checkov:skip=CKV_AZURE_177:Ensure Windows VM enables automatic updates
  #checkov:skip=CKV_AZURE_179:Ensure VM agent is installed
  terminate_notification {
    enabled = "true"
    timeout = "PT10M"
  }
  do_not_run_extensions_on_overprovisioned_machines = "true"
  identity {
    type         = "UserAssigned"
    identity_ids = [var.vm_identity_id]
  }

  os_disk {
    storage_account_type = var.os_storage_account_type
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "nic-app-${var.resource_prefix}-${var.env}-${var.location}-${random_string.app_vmss_suffix.result}"
    primary                       = true
    enable_accelerated_networking = var.enable_accelerated_networking

    ip_configuration {
      name                           = "internal"
      primary                        = true
      subnet_id                      = var.subnet_id
      application_security_group_ids = [var.asg_app_id]
    }
  }

  provisioner "local-exec" {
    command = templatefile("${path.module}/app-vmss-provision.ps1", {
      virtualMachineScaleSetName = "vmss-app-${var.resource_prefix}-${var.env}-${var.location}-${random_string.app_vmss_suffix.result}"
      resourceGroupName          = var.resource_group_name
      workspaceId                = data.azurerm_log_analytics_workspace.sentinel-workspace.workspace_id
      workspaceKey               = data.azurerm_log_analytics_workspace.sentinel-workspace.primary_shared_key
      vmIdentityClientId         = var.vm_identity_client_id
      appConfigBlobUrl           = var.app_config_url
      appConfigCommand           = random_string.app_vmss_suffix.keepers.provisioning_script_command
    })
    interpreter = ["pwsh", "-Command"]
  }
}

#### app layer scaling rules
resource "azurerm_monitor_autoscale_setting" "app" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "App"
  })
  name                = "app-scale-rules-${var.resource_prefix}-${var.env}-${var.location}-${random_string.app_vmss_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_windows_virtual_machine_scale_set.app.id

  profile {
    name = "ramProfile"

    capacity {
      default = var.app_instance_min
      minimum = var.app_instance_min
      maximum = var.app_instance_max
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.app.id
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
        value     = "2"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_windows_virtual_machine_scale_set.app.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }
}

## ESHA
resource "azurerm_network_interface" "esha-nic" {
  count = var.is_esha_deployed ? 1 : 0
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "ESHA"
  })
  name                = "nic-esha-${var.resource_prefix}-${var.env}-${var.location}-001"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "esha" {
  count = var.is_esha_deployed ? 1 : 0
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier            = "ESHA",
    "Image Version" = var.esha_image_version
  })
  name                = "vm-esha-${var.resource_prefix}-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
  timezone            = var.time_zone

  zone = try(var.vm_zone, null)

  size               = var.is_small_environment ? var.small_esha_image_size : var.esha_image_size
  admin_username     = "invauser"
  admin_password     = var.admin_password
  source_image_id    = data.azurerm_shared_image_version.esha.id
  provision_vm_agent = true
  #checkov:skip=CKV_AZURE_177:Ensure Windows VM enables automatic updates
  #checkov:skip=CKV_AZURE_50:We will always skip this. This the check `Ensure Virtual Machine Extensions are not Installed`
  #checkov:skip=CKV_AZURE_97:encryption_at_host_enabled = true
  #checkov:skip=CKV_AZURE_151:Ensure Windows VM enables encryption

  network_interface_ids = [
    azurerm_network_interface.esha-nic[0].id,
  ]

  os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.vm_identity_id]
  }

  enable_automatic_updates = false
  patch_mode               = "Manual"
}

resource "azurerm_network_interface_application_security_group_association" "nic_asg_esha_association" {
  count                         = var.is_esha_deployed ? 1 : 0
  network_interface_id          = azurerm_network_interface.esha-nic[0].id
  application_security_group_id = var.asg_esha_id
}

resource "azurerm_virtual_machine_extension" "esha_sentinel_log" {
  count                = var.is_esha_deployed ? 1 : 0
  name                 = "esha-MMAgent"
  virtual_machine_id   = azurerm_windows_virtual_machine.esha[0].id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  tags = merge(var.common_tags, {
    Tier = "ESHA"
  })

  settings = <<SETTINGS
        {
          "workspaceId": "${data.azurerm_log_analytics_workspace.sentinel-workspace.workspace_id}"
        }
        SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${data.azurerm_log_analytics_workspace.sentinel-workspace.primary_shared_key}"
        }
        PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "esha_config" {
  count                      = var.is_esha_deployed ? 1 : 0
  name                       = "esha_config"
  virtual_machine_id         = azurerm_windows_virtual_machine.esha[0].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  tags = merge(var.common_tags, {
    Tier = "ESHA"
  })

  protected_settings = <<PROTECTED_SETTINGS
        {
          "fileUris": ["${var.esha_config_url}"],
          "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File ${var.esha_config_blob} -ad_pass \"${var.domain_account_password}\"",
          "managedIdentity": {"clientId": "${var.vm_identity_client_id}"}
        }
  PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.esha_sentinel_log[0]
  ]
}
