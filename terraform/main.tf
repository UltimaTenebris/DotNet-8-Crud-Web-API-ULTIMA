# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Azure Container Registry (ACR)
# Stores your Docker images
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 3. App Service Plan
# Must be Linux to run Docker containers natively
resource "azurerm_service_plan" "plan" {
  name                = "asp-bestrong-docker"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# 4. Linux Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      # Points to the image we will push in the CI/CD pipeline
      docker_image     = "${azurerm_container_registry.acr.login_server}/dotnet-crud-api"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    # Maps Azure's port 80 to your container's port 8080
    "WEBSITES_PORT" = "8080" 
    
    # Credentials to allow App Service to pull from ACR
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
  }
}