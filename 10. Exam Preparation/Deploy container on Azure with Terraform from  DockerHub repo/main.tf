terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.59.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "LibraryRG"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "librarybaido"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "example" {
  name                 = "librarybaido-share"
  storage_account_name = azurerm_storage_account.example.name
  quota                = 50
}

resource "azurerm_container_group" "example" {
  name                = "Library"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  ip_address_type     = "Public"
  dns_name_label      = "library-baido"
  os_type             = "Linux"

  container {
    name   = "web-app"
    image  = "bloodtaint/library" # Replace with your ACR registry and image name
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }


  container {
    name   = "sqlserver"
    image  = "mcr.microsoft.com/mssql/server" # Replace with your MSSQL image
    cpu    = "2"
    memory = "2"

    ports {
      port     = 1433
      protocol = "TCP"
    }

    environment_variables = {
      "MSSQL_SA_PASSWORD" = "yourStrongPassword12#",
      "ACCEPT_EULA"       = "Y",
    }

    # Define the persistent volume mount for data storage
    volume {
      name       = "database-storage-baido"
      mount_path = "/var/opt/mssql"

      read_only  = false
      share_name = azurerm_storage_share.example.name

      storage_account_name = azurerm_storage_account.example.name
      storage_account_key  = azurerm_storage_account.example.primary_access_key
    }
  }


}