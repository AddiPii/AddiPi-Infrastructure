locals {
  vcn_name           = "vcn-addipi"
  subnet_name        = "subnet-addipi"
  internet_gateway   = "Internet Gateway vcn-addipi"
  route_table_name   = "Default Route Table for vcn-addipi"
  security_list_name = "Default Security List for vcn-addipi"
  dhcp_options_name  = "Default DHCP Options for vcn-addipi"
}

provider "oci" {
  config_file_profile = var.oci_profile
  region              = var.region
}

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr
  display_name   = local.vcn_name
  dns_label      = "vcn05251743"
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = local.internet_gateway
  enabled        = true
}

resource "oci_core_dhcp_options" "this" {
  compartment_id   = var.compartment_ocid
  vcn_id           = oci_core_vcn.this.id
  display_name     = local.dhcp_options_name
  domain_name_type = "CUSTOM_DOMAIN"

  options {
    type               = "DomainNameServer"
    server_type        = "VcnLocalPlusInternet"
    custom_dns_servers = []
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["vcn05251743.oraclevcn.com"]
  }
}

resource "oci_core_route_table" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = local.route_table_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_security_list" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = local.security_list_name

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"

    icmp_options {
      code = 4
      type = 3
    }
  }

  ingress_security_rules {
    protocol = "1"
    source   = "10.0.0.0/16"

    icmp_options {
      type = 3
    }
  }

  ingress_security_rules {
    description = "Files Service"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      min = 5000
      max = 5000
    }
  }

  ingress_security_rules {
    description = "Queue Service"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      min = 3070
      max = 3070
    }
  }

  ingress_security_rules {
    description = "Printer Service"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      min = 3050
      max = 3050
    }
  }

  ingress_security_rules {
    description = "Auth Service"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      min = 3001
      max = 3001
    }
  }

  ingress_security_rules {
    description = "User Service"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      min = 3002
      max = 3002
    }
  }
}

resource "oci_core_subnet" "this" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = var.subnet_cidr
  display_name               = local.subnet_name
  dns_label                  = "subnet05251743"
  route_table_id             = oci_core_route_table.this.id
  dhcp_options_id            = oci_core_dhcp_options.this.id
  security_list_ids          = [oci_core_security_list.this.id]
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_instance" "this" {
  availability_domain = var.instance_availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_display_name
  fault_domain        = var.instance_fault_domain
  shape               = var.instance_shape

  shape_config {
    ocpus         = 1
    memory_in_gbs = 1
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid
  }

  metadata = {
    ssh_authorized_keys = var.instance_ssh_public_key
  }

  create_vnic_details {
    display_name           = var.instance_display_name
    hostname_label         = var.instance_hostname_label
    subnet_id              = oci_core_subnet.this.id
    private_ip             = var.instance_private_ip
    assign_public_ip       = true
    skip_source_dest_check = false
  }
}

resource "oci_core_public_ip" "reserved" {
  compartment_id = var.compartment_ocid
  display_name   = "addipi-reserved-ip"
  lifetime       = "RESERVED"
  private_ip_id  = var.reserved_public_ip_private_ip_id
}
