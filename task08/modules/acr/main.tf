resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = true
  tags                = var.tags
}

# 2. Створюємо завдання (робітника), яке буде збирати наш Docker-образ
resource "azurerm_container_registry_task" "build_app" {
  name                  = var.task_name
  container_registry_id = azurerm_container_registry.acr.id

  platform {
    os = "Linux"
  }

  docker_step {
    dockerfile_path      = "Dockerfile"
    image_names          = ["${var.image_name}:latest"]
    context_path         = var.app_location
    context_access_token = var.git_pat
  }

  # trigger {
  #   base_image_trigger {
  #     name    = "baseImageTrigger"
  #     enabled = false
  #   }
  # }
}