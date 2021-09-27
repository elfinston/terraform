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
  AKAMAI_CLIENT_SECRET = "${var.AKAMAI_JP_CLIENT_SECRET}"
  AKAMAI_HOST = "${var.AKAMAI_JP_HOST}"
  AKAMAI_ACCESS_TOKEN = "${var.AKAMAI_JP_ACCESS_TOKEN}"
  AKAMAI_CLIENT_TOKEN = "${var.AKAMAI_JP_CLIENT_TOKEN}"
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
