variable "resource_group_name" {
  description = "Azure resource group name for AddiPi."
  type        = string
  default     = "AddiPi-RG"
}

variable "resource_group_location" {
  description = "Location of the resource group itself."
  type        = string
  default     = "polandcentral"
}

variable "shared_region" {
  description = "Primary region used by storage, service bus and Cosmos."
  type        = string
  default     = "swedencentral"
}

variable "iot_hub_location" {
  description = "Location of the IoT Hub."
  type        = string
  default     = "switzerlandnorth"
}

variable "storage_account_name" {
  description = "Azure Storage account name used by the files service."
  type        = string
  default     = "addipifiles"
}

variable "servicebus_namespace_name" {
  description = "Azure Service Bus namespace name."
  type        = string
  default     = "addipisb"
}

variable "cosmos_account_name" {
  description = "Azure Cosmos DB account name."
  type        = string
  default     = "addipi-cosmos"
}

variable "iot_hub_name" {
  description = "Azure IoT Hub name."
  type        = string
  default     = "addipi-iothub"
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}