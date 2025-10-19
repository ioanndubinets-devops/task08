resource "azurerm_container_group" "aci" {
  name                = var.aci_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.aci_sku
  os_type             = "Linux"
  tags                = var.tags

  image_registry_credential {
    server   = var.acr_login_server
    username = var.acr_admin_username
    password = var.acr_admin_password
  }

  ip_address_type = "Public"
  dns_name_label  = var.aci_name

  container {
    name   = "redis-flask-app"
    image  = var.image_name_with_tag
    cpu    = 0.5 # Мінімальні ресурси
    memory = 1.0 # Мінімальні ресурси

    # Відкриваємо порт, який ми вказали в Dockerfile
    ports {
      port     = 8080
      protocol = "TCP"
    }

    # Звичайні змінні оточення
    environment_variables = {
      "CREATOR"        = "ACI"
      "REDIS_PORT"     = "6380"
      "REDIS_SSL_MODE" = "True"
    }

    secure_environment_variables = {
      "REDIS_URL" = var.redis_url
      "REDIS_PWD" = var.redis_pwd
    }
  }
}