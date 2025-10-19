variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "aks_name" {
  description = "The name for the AKS cluster."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "aks_node_pool_name" {
  description = "The name for the default node pool."
  type        = string
}

variable "aks_node_pool_count" {
  description = "The number of nodes (VMs) in the node pool."
  type        = number
}

variable "aks_node_pool_size" {
  description = "The size of the VMs for the nodes."
  type        = string
}

variable "aks_node_pool_disk_type" {
  description = "The OS disk type for the nodes."
  type        = string
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Azure Key Vault."
  type        = string
}