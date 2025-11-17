# Cosmos DB
az cosmosdb create --resource-group AddiPi-RG --name addipi-cosmos
az cosmosdb sql database create --resource-group AddiPi-RG --account-name addipi-cosmos --name addipi
az cosmosdb sql container create --resource-group AddiPi-RG --account-name addipi-cosmos --database-name addipi --name jobs --partition-key-path "/id"

# Pobierz klucze
COSMOS_ENDPOINT=$(az cosmosdb show --resource-group AddiPi-RG --name addipi-cosmos --query documentEndpoint -o tsv)
COSMOS_KEY=$(az cosmosdb keys list --resource-group AddiPi-RG --name addipi-cosmos --query primaryMasterKey -o tsv)