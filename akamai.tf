# Load module
terraform {
  required_version = ">=1.0.7"
  required_providers {
    akamai = {
      source = "akamai/akamai"
      version = ">=1.7.0"
    }
  }
}

# Variables declare
variable "AKAMAI_jp-all_CLIENT_SECRET" {}
variable "AKAMAI_jp-all_HOST" {}
variable "AKAMAI_jp-all_ACCESS_TOKEN" {}
variable "AKAMAI_jp-all_CLIENT_TOKEN" {}

# Configure the Akamai Provider
provider "akamai" {
  config {
    client_secret = "${var.AKAMAI_jp-all_CLIENT_SECRET}"
    host = "${var.AKAMAI_jp-all_HOST}"
    access_token = "${var.AKAMAI_jp-all_ACCESS_TOKEN}"
    client_token = "${var.AKAMAI_jp-all_CLIENT_TOKEN}"
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

#Rule File
data "local_file" "rules" {
  filename = "rules.json"
}

# DP Creation
resource "akamai_property" "default" {
  name         = "test02.essl.shki.tokyo"
  product_id   = "prd_Site_Accel"
  contract_id  = data.akamai_contract.default.id
  group_id     = data.akamai_group.default.id
  hostnames {
    cname_from = "test02.essl.shki.tokyo"
    cname_to = "test02.essl.shki.tokyo.edgekey.net"
    cert_provisioning_type = "CPS_MANAGED"
  }
  rule_format = "latest"
  rules = data.local_file.rules.content
}

# Activation Staging
resource "akamai_property_activation" "staging-activation" {
  property_id = akamai_property.default.id
  version = 1
  network = "STAGING"
  contact = ["shki@akamai.com"]
}
  
/*
# Activation Production
resource "akamai_property_activation" "production-activation" {
  property_id = akamai_property.default.id
  version = 1
  network = "PRODUCTION"
  contact = ["shki@akamai.com"]
}
*/
