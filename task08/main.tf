data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

# resource "null_resource" "run_acr_build_task" {
#   # Запускаємо цей крок ТІЛЬКИ ПІСЛЯ того, як ACR та завдання створені
#   depends_on = [module.acr]

#   # Використовуємо 'local-exec' для запуску команди Azure CLI
#   provisioner "local-exec" {
#     # Ця команда примусово запускає завдання, яке ми створили в module.acr
#     command = "az acr task run --name ${local.acr_task_name} --registry ${local.acr_name} --resource-group ${local.rg_name}"
#   }
# }

module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  keyvault_name       = local.keyvault_name
  keyvault_sku        = var.keyvault_sku
  tags                = local.common_tags

  # Даємо доступ поточному користувачу (тобі)
  current_user_object_id = data.azurerm_client_config.current.object_id
  tenant_id              = data.azurerm_client_config.current.tenant_id
}

module "redis" {
  source = "./modules/redis"
  # Залежність: чекаємо, поки Key Vault буде готовий
  depends_on = [module.keyvault]

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  redis_name          = local.redis_name
  redis_capacity      = var.redis_capacity
  redis_sku           = var.redis_sku
  redis_sku_family    = var.redis_sku_family
  tags                = local.common_tags

  # Передаємо ID "сейфу", куди класти секрети
  key_vault_id = module.keyvault.key_vault_id
  # Передаємо імена для секретів
  redis_hostname_secret_name    = local.redis_hostname_secret_name
  redis_primary_key_secret_name = local.redis_primary_key_secret_name
}

module "acr" {
  source = "./modules/acr"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  acr_name            = local.acr_name
  acr_sku             = var.acr_sku
  image_name          = local.image_name
  tags                = local.common_tags
  git_pat             = var.git_pat
  #os_cont_registry    = "Linux"
  # Шлях до папки з кодом
  app_location = "${var.git_repo_url}#main:application"
  task_name    = local.acr_task_name
}

resource "azurerm_container_registry_task_schedule_run_now" "run_build" {
  # Запускаємо ТІЛЬКИ ПІСЛЯ того, як саме завдання створено
  container_registry_task_id = module.acr.task_id
}

module "aks" {
  source = "./modules/aks"
  # Залежність: чекаємо на ACR і Key Vault
  depends_on = [module.acr, module.keyvault]

  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  aks_name                = local.aks_name
  tags                    = local.common_tags
  aks_node_pool_name      = local.aks_node_pool_name
  aks_node_pool_count     = var.aks_node_pool_count
  aks_node_pool_size      = var.aks_node_pool_size
  aks_node_pool_disk_type = var.aks_node_pool_disk_type

  # Даємо ID "складу" (ACR) та "сейфу" (KV)
  acr_id       = module.acr.acr_id
  key_vault_id = module.keyvault.key_vault_id
}

# --- 3. Читаємо секрети для ACI ---
# ACI не вміє сам ходити в Key Vault, тому ми читаємо секрети і передаємо їх.
data "azurerm_key_vault_secret" "redis_url_secret" {
  name         = local.redis_hostname_secret_name
  key_vault_id = module.keyvault.key_vault_id
  # Залежність: чекаємо, поки Redis їх туди покладе
  depends_on = [module.redis]
}

data "azurerm_key_vault_secret" "redis_pwd_secret" {
  name         = local.redis_primary_key_secret_name
  key_vault_id = module.keyvault.key_vault_id
  depends_on   = [module.redis]
}

module "aci" {
  source = "./modules/aci"
  # Залежність: чекаємо на ACR (щоб був образ) і на секрети
  depends_on          = [azurerm_container_registry_task_schedule_run_now.run_build, data.azurerm_key_vault_secret.redis_pwd_secret]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  aci_name            = local.aci_name
  aci_sku             = var.aci_sku
  tags                = local.common_tags

  # Дані для входу на "склад" (ACR)
  acr_login_server    = module.acr.acr_login_server
  acr_admin_username  = module.acr.acr_admin_username
  acr_admin_password  = module.acr.acr_admin_password
  image_name_with_tag = "${module.acr.acr_login_server}/${local.image_name}:latest"

  # Передаємо прочитані секрети
  redis_url = data.azurerm_key_vault_secret.redis_url_secret.value
  redis_pwd = data.azurerm_key_vault_secret.redis_pwd_secret.value
}

provider "kubernetes" {
  alias = "aks_cluster" # Даємо псевдонім

  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

provider "kubectl" {
  alias = "aks_cluster" # Такий самий псевдонім

  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  load_config_file       = false
}

locals {
  k8s_manifest_vars = {
    # Дані для SecretProviderClass
    aks_kv_access_identity_id  = module.aks.aks_kv_access_identity_id
    kv_name                    = module.keyvault.key_vault_name
    redis_url_secret_name      = local.redis_hostname_secret_name
    redis_password_secret_name = local.redis_primary_key_secret_name
    tenant_id                  = data.azurerm_client_config.current.tenant_id

    # Дані для Deployment
    acr_login_server = module.acr.acr_login_server
    app_image_name   = local.image_name
    image_tag        = "latest" # Можна також зробити змінною
  }
}

resource "kubectl_manifest" "k8s_secret_provider" {
  # Залежність: чекаємо, поки AKS буде готовий
  provider   = kubectl.aks_cluster
  depends_on = [azurerm_container_registry_task_schedule_run_now.run_build]
  # Рендеримо шаблон, заповнюючи його нашими змінними
  yaml_body = templatefile("${path.root}/k8s-manifests/secret-provider.yaml.tftpl", local.k8s_manifest_vars)
}

resource "kubectl_manifest" "k8s_deployment" {
  # Залежність: чекаємо, поки SecretProvider буде готовий
  provider   = kubectl.aks_cluster
  depends_on = [kubectl_manifest.k8s_secret_provider]

  yaml_body = templatefile("${path.root}/k8s-manifests/deployment.yaml.tftpl", local.k8s_manifest_vars)

  # Чекаємо, поки хоча б 1 репліка стане доступною
  wait_for {
    field {
      key   = "status.availableReplicas"
      value = "1"
    }
  }
}

resource "kubectl_manifest" "k8s_service" {
  # Залежність: чекаємо на Deployment
  provider   = kubectl.aks_cluster
  depends_on = [kubectl_manifest.k8s_deployment]

  yaml_body = file("${path.root}/k8s-manifests/service.yaml")

  # Чекаємо, поки Azure виділить нам публічну IP-адресу
  wait_for {
    field {
      key        = "status.loadBalancer.ingress.[0].ip"
      value      = "^(\\d+(\\.|$)){4}" # Регулярний вираз для перевірки IP
      value_type = "regex"
    }
  }
}

data "kubernetes_service" "app_service" {
  provider = kubernetes.aks_cluster
  # Залежність: чекаємо, поки сервіс точно отримає IP
  depends_on = [kubectl_manifest.k8s_service]

  metadata {
    name = "redis-flask-app-service" # Ім'я з service.yaml
  }
}