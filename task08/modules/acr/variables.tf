variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "acr_name" {
  description = "The name for the Azure Container Registry."
  type        = string
}

variable "acr_sku" {
  description = "The SKU of the ACR (e.g., 'Basic', 'Standard', 'Premium')."
  type        = string
}

variable "image_name" {
  description = "The name of the Docker image to be built."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}

variable "git_pat" {
  description = "A Personal Access Token for the Git repository."
  type        = string
  # Важливо: це секрет, тому не відображаємо його в логах
  sensitive = true
}

variable "app_location" {
  description = "The local path to the application source code."
  type        = string
}

variable "task_name" {
  description = "The name for the ACR Task."
  type        = string
}

# variable "os_cont_registry" {
#   description = ".."
#   type        = string
# }