resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.aks_name}-dns"

  default_node_pool {
    name         = var.aks_node_pool_name
    node_count   = var.aks_node_pool_count
    vm_size      = var.aks_node_pool_size
    os_disk_type = var.aks_node_pool_disk_type
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "azurerm_key_vault_access_policy" "aks_kv_access" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id

  secret_permissions = [
    "Get",
    "List"
  ]
}


