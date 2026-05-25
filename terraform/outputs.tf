output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "storage_connection_string" {
  value     = azurerm_storage_account.this.primary_connection_string
  sensitive = true
}

output "service_bus_namespace_name" {
  value = azurerm_servicebus_namespace.this.name
}

output "service_bus_connection_string" {
  value     = azurerm_servicebus_namespace_authorization_rule.root_manage.primary_connection_string
  sensitive = true
}

output "cosmos_endpoint" {
  value     = azurerm_cosmosdb_account.this.endpoint
  sensitive = true
}

output "cosmos_key" {
  value     = azurerm_cosmosdb_account.this.primary_key
  sensitive = true
}

output "iot_hub_hostname" {
  value = azurerm_iothub.this.hostname
}

output "blob_container_name" {
  value = azurerm_storage_container.gcode.name
}

output "service_bus_queue_name" {
  value = azurerm_servicebus_queue.print_queue.name
}