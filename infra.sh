#!/bin/bash

# Create Resource Group

az group create --name AddiPi-RG --location eastus


#For Files Service

# ACR (Docker registry)
az acr create --resource-group AddiPi-RG --name addipiacr --sku Basic --admin-enabled true

# Container Instances (gdzie będzie działać)
az container create \
  --resource-group AddiPi-RG \
  --name files-service \
  --image mcr.microsoft.com/azuredocs/aci-helloworld \
  --ports 80


