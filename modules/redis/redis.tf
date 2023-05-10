# variables needed for redis configuration block
locals {
  # see TF registry documentation for variable requirements
  enable_authentication           = "true"
  maxmemory_reserved              = "50"
  maxmemory_delta                 = "50"
  maxmemory_policy                = "volatile-lru"
  maxfragmentationmemory_reserved = "50"
  notify_keyspace_events          = ""
  sku_name                        = contains(["prd", "dbg", "uat"], var.env) ? "Standard" : "Basic"
}

resource "azurerm_redis_cache" "redis" {
  lifecycle {
    ignore_changes = [
      tags["Tier"]
    ]
  }
  tags = merge(var.common_tags, {
    Tier = "Cache"
  })

  name                          = "redis-${var.resource_prefix}-${var.env}-${var.location}-001"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = var.redis_capacity # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache#capacity
  family                        = "C"                # For both Standard and Basic
  sku_name                      = local.sku_name
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
    enable_authentication           = local.enable_authentication
    maxmemory_reserved              = local.maxmemory_reserved
    maxmemory_delta                 = local.maxmemory_delta
    maxmemory_policy                = local.maxmemory_policy
    maxfragmentationmemory_reserved = local.maxfragmentationmemory_reserved
    notify_keyspace_events          = local.notify_keyspace_events
  }
}

moved {
  from = azurerm_redis_cache.redis[0]
  to   = azurerm_redis_cache.redis
}