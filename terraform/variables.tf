variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "rg-bestrong-devops-task"
}

variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry (must be unique, no dashes)"
  default     = "acrbestrongtask2026"
}

variable "app_service_name" {
  description = "Name of the App Service (must be unique)"
  default     = "app-bestrong-api-docker"
}