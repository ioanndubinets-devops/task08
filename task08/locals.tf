locals {
  # 1. Імена, які генеруються з префіксу (з terraform.tfvars)
  rg_name       = "${var.resources_name_prefix}-rg"    # -> cmtr-2j1y6jsc-mod8-rg
  redis_name    = "${var.resources_name_prefix}-redis" # -> cmtr-2j1y6jsc-mod8-redis
  keyvault_name = "${var.resources_name_prefix}-kv"    # -> cmtr-2j1y6jsc-mod8-kv
  aks_name      = "${var.resources_name_prefix}-aks"   # -> cmtr-2j1y6jsc-mod8-aks

  # 2. Імена, які задані жорстко, бо мають унікальний формат
  aci_name           = "cmtr-2j1y6jsc-mod8-ci"
  acr_name           = "cmtr2j1y6jscmod8cr"
  image_name         = "cmtr-2j1y6jsc-mod8-app"
  aks_node_pool_name = "system"
  # 3. Імена секретів
  redis_primary_key_secret_name = "redis-primary-key"
  redis_hostname_secret_name    = "redis-hostname"
  acr_task_name                 = "${var.resources_name_prefix}-build-task"
  # 4. Теги
  common_tags = {
    Creator = var.student_email
  }
}

