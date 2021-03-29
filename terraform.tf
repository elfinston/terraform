# Load module
terraform {
  required_version = "0.14.8"
  required_providers {
    akamai = {
      source = "akamai/akamai"
      version = "1.4.0"
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

# Rule Tree
data "local_file" "rules" {
  filename = "rules.json"
}

data "akamai_contract" "default" {
  group_id = "grp_179232"
}

data "akamai_group" "default" {
  group_name  = "shki"
  contract_id = "ctr_1-GNLXD"
}

# EdgeDNS CNAME record
resource "akamai_dns_record" "a_record" {
  zone       = "shki.tokyo"
  name       = "terraform01.ff-duma.shki.tokyo"
  recordtype = "CNAME"
  ttl        = "600"
  target     = ["terraform01.ff-duma.shki.tokyo.edgesuite.net."]
}

# EdgeDNS Origin A record
resource "akamai_dns_record" "a_record-origin_hostname" {
  zone       = "shki.tokyo"
  name       = "terraform01-origin.shki.tokyo"
  recordtype = "A"
  ttl        = "600"
  target     = ["13.112.26.181"]
}

# CP code Create
resource "akamai_cp_code" "default" {
  name        = "shki-terraform01"
  contract_id = data.akamai_contract.default.id
  group_id    = data.akamai_group.default.id
  product_id  = "prd_Fresca"
}

# DP Edge hostname
resource "akamai_edge_hostname" "default" {
  product_id    = "prd_Fresca"
  contract_id   = data.akamai_contract.default.id
  group_id      = data.akamai_group.default.id
  edge_hostname = "terraform01.ff-duma.shki.tokyo.edgesuite.net"
  ip_behavior   = "IPV6_COMPLIANCE"
  certificate   = "105356"
}

# DP Creation
resource "akamai_property" "default" {
  name         = "terraform01.ff-duma.shki.tokyo"
  product_id   = "prd_Fresca"
  contract_id  = data.akamai_contract.default.id
  group_id     = data.akamai_group.default.id

  hostnames  = {
    "terraform01.ff-duma.shki.tokyo" = akamai_edge_hostname.default.edge_hostname
  }

  rule_format = "latest"
  rules = data.local_file.rules.content
}

# Activation
resource "akamai_property_activation" "staging-activation" {
  property_id = akamai_property.default.id
  version = akamai_property.default.latest_version
  network = "STAGING"
  contact = ["shki@akamai.com"]
}
