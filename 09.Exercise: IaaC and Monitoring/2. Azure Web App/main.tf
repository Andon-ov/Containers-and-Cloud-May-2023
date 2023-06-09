# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.59.0"
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}


# Generate a random integer for resource naming
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "contact-book-rg-${random_integer.ri.result}"
  location = "West Europe"

}

# Create an App Service Plan
resource "azurerm_service_plan" "appsp" {
  name                = "contact-book-appsp-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"

}

# Create an Azure Linux Web App
resource "azurerm_linux_web_app" "appservice" {
  name                = "contact-book-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.appsp.location
  service_plan_id     = azurerm_service_plan.appsp.id

  site_config {
    application_stack {
      node_version = "16-lts"
    }

    always_on = false
  }
}



# Deploy code from GitHub repo to Azure Web App
resource "azurerm_app_service_source_control" "git" {
  app_id   = azurerm_linux_web_app.appservice.id
  repo_url = "https://github.com/nakov/ContactBook"
  branch   = "master"

  use_manual_integration = true
}