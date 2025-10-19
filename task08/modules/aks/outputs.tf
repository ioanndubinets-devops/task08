output "kube_config_raw" {
  description = "."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "aks_kv_csi_driver_identity_client_id" {
  description = "The Client ID of the Key Vault CSI driver identity for AKS."
  # Беремо Client ID нашої НОВОЇ ідентичності
  value = azurerm_user_assigned_identity.aks_csi_identity.client_id
}

output "cluster_name" {
  description = "name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
  sensitive = true

}

output "aks_acr_pull_role_assignment_id" {
  description = "The ID of the AcrPull role assignment for AKS."
  value       = azurerm_role_assignment.aks_acr_pull.id
}

