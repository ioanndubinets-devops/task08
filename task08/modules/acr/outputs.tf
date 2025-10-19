output "acr_login_server" {
  description = "s"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "The admin username of the ACR."
  value       = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  description = "The admin password of the ACR."
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "acr_id" {
  description = "The ID of the ACR."
  value       = azurerm_container_registry.acr.id
}

output "task_id" {
  description = "The ID of the ACR Task."
  value       = azurerm_container_registry_task.build_app.id
}