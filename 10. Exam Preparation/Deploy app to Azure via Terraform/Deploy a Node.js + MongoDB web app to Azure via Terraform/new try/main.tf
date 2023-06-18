terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.59.0"
    }
    azurerm_key_vault = {
      source  = "hashicorp/azurerm"
      version = ">=2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm_key_vault" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "West Europe"
}

resource "azurerm_key_vault" "example" {
  name                = "example-key-vault"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  enabled_for_disk_encryption = true
  sku_name            = "standard"
  tenant_id           = var.azure_tenant_id
}

resource "azurerm_linux_web_app" "example" {
  name                = "example-web-app"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
  application_stack {
    node_version = "16-lts"
  }

  always_on = false
}

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = azurerm_key_vault_secret.example.value
  }
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-secret"
  key_vault_id = azurerm_key_vault.example.id
  value        = "example-secret-value"
}
