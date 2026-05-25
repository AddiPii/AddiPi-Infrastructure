import {
  to = azurerm_resource_group.this
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG"
}

import {
  to = azurerm_storage_account.this
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.Storage/storageAccounts/addipifiles"
}

import {
  to = azurerm_storage_container.gcode
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.Storage/storageAccounts/addipifiles/blobServices/default/containers/gcode"
}

import {
  to = azurerm_servicebus_namespace.this
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.ServiceBus/namespaces/addipisb"
}

import {
  to = azurerm_servicebus_namespace_authorization_rule.root_manage
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.ServiceBus/namespaces/addipisb/authorizationRules/RootManageSharedAccessKey"
}

import {
  to = azurerm_servicebus_queue.print_queue
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.ServiceBus/namespaces/addipisb/queues/print-queue"
}

import {
  to = azurerm_cosmosdb_account.this
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.DocumentDB/databaseAccounts/addipi-cosmos"
}

import {
  to = azurerm_cosmosdb_sql_database.this
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.DocumentDB/databaseAccounts/addipi-cosmos/sqlDatabases/addipi"
}

import {
  to = azurerm_cosmosdb_sql_container.containers["jobs"]
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.DocumentDB/databaseAccounts/addipi-cosmos/sqlDatabases/addipi/containers/jobs"
}

import {
  to = azurerm_cosmosdb_sql_container.containers["users"]
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.DocumentDB/databaseAccounts/addipi-cosmos/sqlDatabases/addipi/containers/users"
}

import {
  to = azurerm_cosmosdb_sql_container.containers["refresh-tokens"]
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.DocumentDB/databaseAccounts/addipi-cosmos/sqlDatabases/addipi/containers/refresh-tokens"
}

import {
  to = azurerm_iothub.this
  id = "/subscriptions/1e54ce39-ee89-46b4-9384-7146197f566e/resourceGroups/AddiPi-RG/providers/Microsoft.Devices/iotHubs/addipi-iothub"
}