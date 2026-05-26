output "vcn_id" {
  value = oci_core_vcn.this.id
}

output "subnet_id" {
  value = oci_core_subnet.this.id
}

output "instance_id" {
  value = oci_core_instance.this.id
}

output "public_ip" {
  value = oci_core_public_ip.reserved.ip_address
}

output "private_ip" {
  value = var.instance_private_ip
}