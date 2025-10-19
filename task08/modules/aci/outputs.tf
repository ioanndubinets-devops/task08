output "aci_fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the ACI."
  value       = azurerm_container_group.aci.fqdn
}

output "aci_ip_address" {
  description = "The public IP address of the ACI."
  value       = azurerm_container_group.aci.ip_address
}