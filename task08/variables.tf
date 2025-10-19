variable "resources_name_prefix" {
  description = "A prefix used to generate unique names for all resources."
  type        = string
}

variable "student_email" {
  description = "Your email, used for the 'Creator' tag."
  type        = string
}

variable "location" {
  description = "The Azure region where all resources will be deployed."
  type        = string
  default     = "East US"
}

variable "git_pat" {
  description = "Personal Access Token for Git to allow ACR Task to access code."
  type        = string
  sensitive   = true
}

variable "redis_capacity" {
  description = "Capacity for Redis."
  type        = number
  default     = 0
}

variable "redis_sku" {
  description = "SKU for Redis."
  type        = string
  default     = "Basic"
}

variable "redis_sku_family" {
  description = "SKU Family for Redis."
  type        = string
  default     = "C"
}

variable "keyvault_sku" {
  description = "SKU for Key Vault."
  type        = string
  default     = "standard"
}

variable "acr_sku" {
  description = "SKU for ACR."
  type        = string
  default     = "Standard"
}

variable "aci_sku" {
  description = "SKU for ACI."
  type        = string
  default     = "Standard"
}

variable "aks_node_pool_count" {
  description = "Number of nodes in the AKS default pool."
  type        = number
  default     = 1
}

variable "aks_node_pool_size" {
  description = "VM size for the AKS nodes."
  type        = string
  default     = "Standard_B2s"
}

variable "aks_node_pool_disk_type" {
  description = "Disk type for the AKS nodes."
  type        = string
  default     = "Managed"
}

variable "git_repo_url" {
  description = "The URL of the Git repository containing the application code."
  type        = string
}