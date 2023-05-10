output "redis_hostname" {
  value = azurerm_redis_cache.redis.hostname
}

output "redis_name" {
  value = azurerm_redis_cache.redis.name
}

output "redis_id" {
  value = azurerm_redis_cache.redis.id
}

output "redis_ssl_port" {
  value = azurerm_redis_cache.redis.ssl_port
}

output "redis_non_ssl_port" {
  value = azurerm_redis_cache.redis.port
}

output "redis_pass" {
  value = azurerm_redis_cache.redis.primary_access_key
}
