# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.59.0"
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${random_integer.ri.result}"
  location = var.resource_group_location
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appsp" {
  name                = "${var.app_service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "appservice" {
  name                = "${var.app_service_name}-${random_integer.ri.result}"
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

# Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "git" {
  app_id                 = azurerm_linux_web_app.appservice.id
  repo_url               = var.repo_URL
  branch                 = "main"
  use_manual_integration = true
}

# Create Azure Cosmos DB account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "${var.cosmosdb_account_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  offer_type          = "Standard"

    geo_location {
    location          = var.resource_group_location  # Replace with your desired location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level = "Session"  # Replace with your desired consistency level
  }
}

# Create Azure Cosmos DB SQL API database
resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql" {
  name                = var.cosmosdb_database_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  throughput          = 400
}

# Create Azure Cosmos DB SQL API container
resource "azurerm_cosmosdb_sql_container" "cosmosdb_container" {
  name                = var.cosmosdb_container_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.cosmosdb_sql.name
  partition_key_path  = "/partitionKey"
  throughput          = 400
}
