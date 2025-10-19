variable "resource_group_name" {
  type        = string
  default     = ""
  description = "description"
}

variable "location" {
  description = "description"
  type        = string
}

variable "keyvault_name" {
  description = "description"
  type        = string
}

variable "keyvault_sku" {
  description = "description"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "current_user_object_id" {
  description = "The Object ID of the current user to grant access policies."
  type        = string
}

variable "tenant_id" {
  description = "The Tenant ID of the Azure subscription."
  type        = string
}
