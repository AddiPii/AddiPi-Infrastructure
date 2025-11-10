#!/bin/bash
source .env

echo "DEPLOYING ADDI PI FILES SERVICE"

docker build -t addi-pi/files-service .

az acr login --name addipiacr
docker tag addi-pi/files-service addipiacr.azurecr.io/files-service:latest
docker push addipiacr.azurecr.io/files-service:latest

az container delete --resource-group AddiPi-RG --name files-service --yes || true
az container create --resource-group AddiPi-RG --name files-service --image addipiacr.azurecr.io/files-service:latest --ports 5000 --environment-variables STORAGE_CONN="$STORAGE_CONN" SERVICE_BUS_CONN="$SERVICE_BUS_CONN" --dns-name-label addipi-files

sleep 30  # Czekaj na start
IP=$(az container show --resource-group AddiPi-RG --name files-service --query ipAddress.ip -o tsv)
echo "✅ DEPLOYED!"
echo "🌐 URL: http://$IP:5000"
echo "🧪 TEST: curl -X POST -F 'file=@cube.gcode' http://$IP:5000/upload"