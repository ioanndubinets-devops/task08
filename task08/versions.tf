terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
  }
}

# --- ГОЛОВНА ЧАСТИНА ---

provider "azurerm" {
  features {}
}

# ЦЕЙ БЛОК ВКАЗУЄ, ЩО ТРЕБА ЧЕКАТИ НА module.aks
# provider "kubernetes" {
#   host                   = module.aks.host
#   client_certificate     = base64decode(module.aks.client_certificate)
#   client_key             = base64decode(module.aks.client_key)
#   cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
# }

# # І ЦЕЙ БЛОК ТЕЖ ВКАЗУЄ, ЩО ТРЕБА ЧЕКАТI
# provider "kubectl" {
#   host                   = module.aks.host
#   client_certificate     = base64decode(module.aks.client_certificate)
#   client_key             = base64decode(module.aks.client_key)
#   cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
#   load_config_file       = false
# }

# provider "kubernetes" {
#   alias = "aks_provider" # Даємо йому псевдонім

#   host                   = module.aks.host
#   client_certificate     = base64decode(module.aks.client_certificate)
#   client_key             = base64decode(module.aks.client_key)
#   cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
# }

# provider "kubectl" {
#   alias = "aks_provider" # Даємо йому такий самий псевдонім

#   host                   = module.aks.host
#   client_certificate     = base64decode(module.aks.client_certificate)
#   client_key             = base64decode(module.aks.client_key)
#   cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
#   load_config_file       = false
# }

