variable "oci_config_file_path" {
  type        = string
  description = "Path to the OCI CLI config file."
  default     = "~/.oci/config"
}

variable "oci_profile" {
  type        = string
  description = "OCI CLI profile used by Terraform."
  default     = "DEFAULT"
}

variable "region" {
  type        = string
  description = "OCI region."
  default     = "eu-frankfurt-1"
}

variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID used for the current AddiPi OCI stack."
  default     = "<COMPARTMENT_OCID>"
}

variable "vcn_cidr" {
  type        = string
  description = "CIDR block for the AddiPi VCN."
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the AddiPi subnet."
  default     = "10.0.0.0/24"
}

variable "instance_display_name" {
  type        = string
  description = "Display name of the running AddiPi instance."
  default     = "addipi"
}

variable "instance_availability_domain" {
  type        = string
  description = "Availability domain of the running instance."
  default     = "NzDJ:EU-FRANKFURT-1-AD-2"
}

variable "instance_fault_domain" {
  type        = string
  description = "Fault domain of the running instance."
  default     = "FAULT-DOMAIN-3"
}

variable "instance_shape" {
  type        = string
  description = "Shape of the current instance."
  default     = "VM.Standard.E2.1.Micro"
}

variable "instance_image_ocid" {
  type        = string
  description = "Source image OCID used by the current instance."
  default     = "<IMAGE_OCID>"
}

variable "instance_private_ip" {
  type        = string
  description = "Primary private IP of the current instance."
  default     = "10.0.0.207"
}

variable "instance_hostname_label" {
  type        = string
  description = "Hostname label of the current instance VNIC."
  default     = "addipi-269871"
}

variable "instance_ssh_public_key" {
  type        = string
  description = "SSH public key currently configured on the instance."
  default     = "<SSH_PUBLIC_KEY>"
}

variable "reserved_public_ip_private_ip_id" {
  type        = string
  description = "Private IP OCID attached to the reserved public IP."
  default     = "<PRIVATE_IP_OCID>"
}