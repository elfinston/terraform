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
  group_name  = var.group_name
  contract_id = "ctr_1-GNLXD"
}

# Declear network-lists
data "akamai_networklist_network_lists" "network_lists_filter" {
}
