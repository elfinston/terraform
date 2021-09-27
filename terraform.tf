# Load module
terraform {
  required_version = ">=1.0.7"
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">=1.7.0"
    }
  }
}

# Variables
variable "AKAMAI_JP_CLIENT_SECRET" {}
variable "AKAMAI_JP_HOST" {}
variable "AKAMAI_JP_ACCESS_TOKEN" {}
variable "AKAMAI_JP_CLIENT_TOKEN" {}

# Configure the Akamai Provider
provider "akamai" {
  config {
    client_secret = "${var.AKAMAI_JP_CLIENT_SECRET}"
    host = "${var.AKAMAI_JP_HOST}"
    access_token = "${var.AKAMAI_JP_ACCESS_TOKEN}"
    client_token = "${var.AKAMAI_JP_CLIENT_TOKEN}"
  }
}

# Contract and Group
data "akamai_contract" "default" {
  group_id = "grp_179232"
}

data "akamai_group" "default" {
  group_name  = "shki"
  contract_id = "ctr_1-GNLXD"
}

data "akamai_iam_contact_types" "contact_types" {
}

output "supported_contact_types" {
  value = data.akamai_iam_contact_types.contact_types
}

data "akamai_iam_countries" "countries" {
}

output "supported_countries" {
  value = data.akamai_iam_countries.countries
}

data "akamai_iam_groups" "my-groups" {}

output "groups" {
  value = data.akamai_iam_groups.my-groups
}

data "akamai_iam_roles" "my-roles" {}

output "roles" {
  value = data.akamai_iam_roles.my-roles
}

data "akamai_iam_supported_langs" "supported_langs" {
}

output "supported_supported_langs" {
  value = data.akamai_iam_supported_langs.supported_langs
}

data "akamai_iam_timeout_policies" "timeout_policies" {
}

output "supported_timeout_policies" {
  value = data.akamai_iam_timeout_policies.timeout_policies
}
