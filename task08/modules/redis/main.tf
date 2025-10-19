resource "azurerm_redis_cache" "redis_cache" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_capacity
  family              = var.redis_sku_family
  sku_name            = var.redis_sku

  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"

  tags = var.tags
}

resource "azurerm_key_vault_secret" "redis_hostname" {
  name         = var.redis_hostname_secret_name
  key_vault_id = var.key_vault_id

  value = azurerm_redis_cache.redis_cache.hostname
}

resource "azurerm_key_vault_secret" "redis_primary_key" {
  name         = var.redis_primary_key_secret_name
  key_vault_id = var.key_vault_id

  value = azurerm_redis_cache.redis_cache.primary_access_key
}