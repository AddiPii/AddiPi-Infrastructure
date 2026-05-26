# AddiPi OCI Terraform

Terraform baseline for the current Oracle Cloud stack discovered with `oci` CLI.

## Covered resources
- VCN `vcn-addipi`
- Subnet `subnet-addipi`
- Internet Gateway, route table, DHCP options, security list
- Compute instance `addipi`
- Reserved public IP `addipi-reserved-ip`

## Usage
```bash
cd AddiPi-Infrastructure/terraform-oci
terraform init
terraform validate
terraform plan
```

## Notes
- Uses the local OCI CLI config from `~/.oci/config` by default.
- The example tfvars only needs the profile, region, tenancy OCID, and SSH public key.
- Keep `terraform.tfstate` out of Git; the parent `.gitignore` already ignores `*.tfstate` and `.terraform/`.