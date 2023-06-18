variable "resource_group_name" {
  type        = string
  default     = "my-resource-group"
  description = "Name of the resource group"
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group"
}

variable "app_service_plan_name" {
  type        = string
  default     = "my-app-service-plan"
  description = "Name of the App Service Plan"
}

variable "app_service_name" {
  type        = string
  default     = "my-web-app"
  description = "Name of the web app"
}

variable "repo_URL" {
  type        = string
  default     = "https://github.com/myusername/myrepo"
  description = "URL of the GitHub repository"
}

variable "cosmosdb_account_name" {
  type        = string
  default     = "my-cosmosdb-account"
  description = "Name of the Cosmos DB account"
}

variable "cosmosdb_database_name" {
  type        = string
  default     = "my-cosmosdb-database"
  description = "Name of the Cosmos DB database"
}

variable "cosmosdb_container_name" {
  type        = string
  default     = "my-cosmosdb-container"
  description = "Name of the Cosmos DB container"
}

variable "cosmosdb_database_throughput" {
  type        = number
  default     = 400
  description = "Throughput for the Cosmos DB database"
  validation {
    condition     = var.cosmosdb_database_throughput >= 400 && var.cosmosdb_database_throughput <= 1000000
    error_message = "Cosmos DB manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
  }
  validation {
    condition     = var.cosmosdb_database_throughput % 100 == 0
    error_message = "Cosmos DB throughput should be in increments of 100."
  }
}

variable "cosmosdb_container_throughput" {
  type        = number
  default     = 400
  description = "Throughput for the Cosmos DB container"
  validation {
    condition     = var.cosmosdb_container_throughput >= 400 && var.cosmosdb_container_throughput <= 1000000
    error_message = "Cosmos DB manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
  }
  validation {
    condition     = var.cosmosdb_container_throughput % 100 == 0
    error_message = "Cosmos DB throughput should be in increments of 100."
  }
}
