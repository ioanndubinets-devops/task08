variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "aci_name" {
  description = "The name for the Azure Container Instance."
  type        = string
}

variable "aci_sku" {
  description = "The SKU for the ACI."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "acr_login_server" {
  description = "The login server of the ACR."
  type        = string
}

variable "acr_admin_username" {
  description = "The admin username of the ACR."
  type        = string
}

variable "acr_admin_password" {
  description = "The admin password of the ACR."
  type        = string
  sensitive   = true
}

variable "image_name_with_tag" {
  description = "The full name and tag of the Docker image (e.g., myapp:latest)."
  type        = string
}

variable "redis_url" {
  description = "The hostname of the Redis cache."
  type        = string
  sensitive   = true
}

variable "redis_pwd" {
  description = "The primary key for the Redis cache."
  type        = string
  sensitive   = true
}