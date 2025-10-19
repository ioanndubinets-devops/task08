variable "resource_group_name" {
  description = "desc."
  type        = string
}

variable "location" {
  description = "desc."
  type        = string
}

variable "redis_name" {
  description = "desc."
  type        = string
}

variable "redis_capacity" {
  description = "desc."
  type        = number
}

variable "redis_sku" {
  description = "desc."
  type        = string
}

variable "redis_sku_family" {
  description = "desc."
  type        = string
}

variable "tags" {
  description = "desc."
  type        = map(string)
}

variable "key_vault_id" {
  description = "desc."
  type        = string
}

variable "redis_hostname_secret_name" {
  description = "desc."
  type        = string
}

variable "redis_primary_key_secret_name" {
  description = "desc"
  type        = string
}