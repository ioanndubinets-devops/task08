output "redis_id" {
  description = "The ID of the Azure Cache for Redis."
  value       = azurerm_redis_cache.redis_cache.id
}

output "redis_hostname" {
  description = "The hostname of the Azure Cache for Redis."
  value       = azurerm_redis_cache.redis_cache.hostname
}

output "redis_primary_key" {
  description = "The primary access key for the Azure Cache for Redis."
  value       = azurerm_redis_cache.redis_cache.primary_access_key
  # Позначаємо, що це чутливі дані, і Terraform не буде показувати їх у консолі
  sensitive = true
}