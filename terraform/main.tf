locals {
  blob_container_name  = "gcode"
  cosmos_database_name = "addipi"
  cosmos_containers = {
    jobs           = "/id"
    users          = "/id"
    refresh-tokens = "/userId"
  }
  service_bus_queue_name = "print-queue"
  common_tags            = var.tags
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = var.shared_region
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  tags                            = local.common_tags
}

resource "azurerm_storage_container" "gcode" {
  name                  = local.blob_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_servicebus_namespace" "this" {
  name                = var.servicebus_namespace_name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.shared_region
  sku                 = "Basic"
  tags                = local.common_tags
}

resource "azurerm_servicebus_namespace_authorization_rule" "root_manage" {
  name         = "RootManageSharedAccessKey"
  namespace_id = azurerm_servicebus_namespace.this.id
  listen       = true
  send         = true
  manage       = true
}

resource "azurerm_servicebus_queue" "print_queue" {
  name         = local.service_bus_queue_name
  namespace_id = azurerm_servicebus_namespace.this.id

  max_delivery_count                   = 10
  default_message_ttl                  = "P14D"
  dead_lettering_on_message_expiration = false
  partitioning_enabled                 = false
  batched_operations_enabled           = true
}

resource "azurerm_cosmosdb_account" "this" {
  name                          = var.cosmos_account_name
  location                      = var.shared_region
  resource_group_name           = azurerm_resource_group.this.name
  offer_type                    = "Standard"
  kind                          = "GlobalDocumentDB"
  free_tier_enabled             = true
  analytical_storage_enabled    = true
  automatic_failover_enabled    = true
  public_network_access_enabled = true
  tags                          = local.common_tags

  capacity {
    total_throughput_limit = 1000
  }

  backup {
    type = "Continuous"
    tier = "Continuous7Days"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.shared_region
    failover_priority = 0
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = local.cosmos_database_name
  resource_group_name = azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = 1000
}

resource "azurerm_cosmosdb_sql_container" "containers" {
  for_each            = local.cosmos_containers
  name                = each.key
  resource_group_name = azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this.name
  partition_key_paths = [each.value]
}

resource "azurerm_iothub" "this" {
  name                      = var.iot_hub_name
  resource_group_name       = azurerm_resource_group.this.name
  location                  = var.iot_hub_location
  event_hub_partition_count = 2

  sku {
    name     = "F1"
    capacity = 1
  }

  lifecycle {
    ignore_changes = [file_upload]
  }
}