# Terraform for AddiPi

This directory was derived from the live Azure configuration discovered with Azure CLI.

What it currently models:
- Resource group `AddiPi-RG`
- Storage account `addipifiles` and blob container `gcode`
- Service Bus namespace `addipisb`, root auth rule, and queue `print-queue`
- Cosmos DB account `addipi-cosmos`, SQL database `addipi`, and containers `jobs`, `users`, `refresh-tokens`
- IoT Hub `addipi-iothub`

What it does not model yet:
- ACR, because no registry with the expected name exists in the live resource group right now
- Any additional app secrets or connection strings; those should stay in secret storage

Usage:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

The `imports.tf` file contains import blocks for the live resources so the state can be aligned instead of recreated.