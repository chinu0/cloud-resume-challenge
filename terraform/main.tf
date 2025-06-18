terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.32.0"
    }
  }
}


provider "azurerm" {
  subscription_id = "##################################"
  client_id = "###################################"

  tenant_id = "##################################"
  features {}
}

resource "azurerm_resource_group" "visitor-rg" {
  name     = "visitor-counter-rg"
  location = "East US"
}


resource "azurerm_storage_account" "resume_storage" {
  name                     = "chinmayvisitorstorage"
  resource_group_name      = azurerm_resource_group.visitor-rg.name
  location                 = azurerm_resource_group.visitor-rg.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  allow_nested_items_to_be_public = false
}


resource "azurerm_windows_function_app" "resume_function" {
  name                       = "chinmay-visitor-counter"
  location                   = "Canada Central"
  resource_group_name        = azurerm_resource_group.visitor-rg.name
  service_plan_id = azurerm_app_service_plan.resume_plan.id
  storage_account_name       = azurerm_storage_account.resume_storage.name
  storage_account_access_key = azurerm_storage_account.resume_storage.primary_access_key

  builtin_logging_enabled                        = false
  client_certificate_mode                        = "Required"
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    always_on  = false
    ftps_state = "FtpsOnly"

    application_stack {
      node_version = "~22"
    }

    cors {
      allowed_origins = [
        "https://black-stone-0dd79c50f.6.azurestaticapps.net",
        "https://chinmayvisitorstorage.z13.web.core.windows.net",
        "https://portal.azure.com"
      ]
      support_credentials = false
    }
  }

  tags = {
    "hidden-link: /app-insights-conn-string"         = "InstrumentationKey=c40af2fe-57b5-4988-b4ce-fc9e0f0a708b;IngestionEndpoint=https://canadacentral-1.in.applicationinsights.azure.com/;LiveEndpoint=https://canadacentral.livediagnostics.monitor.azure.com/;ApplicationId=95e49cdd-66fc-4a66-8343-2fc117cdb5b8"
    "hidden-link: /app-insights-instrumentation-key" = "c40af2fe-57b5-4988-b4ce-fc9e0f0a708b"
    "hidden-link: /app-insights-resource-id"         = "/subscriptions/7a57158e-ed89-4f82-a74e-7073856b507b/resourceGroups/visitor-counter-rg/providers/microsoft.insights/components/chinmay-visitor-counter202505211847"
  }
  

  app_settings = {
  FUNCTIONS_WORKER_RUNTIME = "node"
  WEBSITE_RUN_FROM_PACKAGE = "1"
  AzureWebJobsStorage      = azurerm_storage_account.resume_storage.primary_connection_string
  }

    connection_string {
    name  = "CosmosDBConnectionString"
    type  = "Custom"
    value = data.azurerm_cosmosdb_account.visitor_cosmosdb.primary_sql_connection_string
  }
}


resource "azurerm_app_service_plan" "resume_plan" {
  name                = "ASP-visitorcounterrg-9e6d"
  location            = "Canada Central"
  resource_group_name = azurerm_resource_group.visitor-rg.name
  kind                = "FunctionApp"
  reserved            = false

  sku {
    tier     = "Dynamic"
    size     = "Y1"
    capacity = 0
  }

  # tags = {
  #   environment = "dev"
  # }
}



resource "azurerm_cosmosdb_account" "visitor_cosmosdb" {
  name                = "chinmayvisitorcounter"
  location            = "West US 3"
  resource_group_name = azurerm_resource_group.visitor-rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = "West US 3"
    failover_priority = 0
  }

  capabilities {
    name = "EnableServerless"
  }
  automatic_failover_enabled = true

  tags = {
    defaultExperience       = "Core (SQL)"
    hidden-workload-type    = "Learning"
    hidden-cosmos-mmspecial = ""
  }
    

}
data "azurerm_cosmosdb_account" "visitor_cosmosdb" {
  name                = azurerm_cosmosdb_account.visitor_cosmosdb.name
  resource_group_name = azurerm_resource_group.visitor-rg.name
}


resource "azurerm_cosmosdb_sql_database" "visitor_db" {
  name                = "VisitorDB"
  resource_group_name = azurerm_resource_group.visitor-rg.name
  account_name        = azurerm_cosmosdb_account.visitor_cosmosdb.name
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [name]
  }
}






resource "azurerm_cosmosdb_sql_container" "visitor_container" {
  name                  = "CountContainer"
  resource_group_name   = azurerm_resource_group.visitor-rg.name
  account_name          = azurerm_cosmosdb_account.visitor_cosmosdb.name
  database_name         = azurerm_cosmosdb_sql_database.visitor_db.name
  partition_key_version = 2
  partition_key_paths   = ["/id"]

  indexing_policy {
  indexing_mode = "consistent"

  included_path {
    path = "/*"
  }
}


  conflict_resolution_policy {
    mode                     = "LastWriterWins"
    conflict_resolution_path = "/_ts"
  }
}



