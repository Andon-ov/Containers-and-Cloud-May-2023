variable "resource_group_name" {
  type        = string
  description = "Resource group name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "Resource group location in Azure"
}

variable "app_service_plan_name" {
  type        = string
  description = "App Service Plan name in Azure"
}

variable "app_service_name" {
  type        = string
  description = "App Service name in Azure"
}

variable "repo_URL" {
  type        = string
  description = "URL of GitHub repo"
}





variable "mongodb_connection_string" {
  description = "Connection string for MongoDB"
  type        = string
}

variable "mongodb_database_name" {
  description = "Name of the MongoDB database"
  type        = string
}