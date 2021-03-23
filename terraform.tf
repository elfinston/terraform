# Load module
terraform {
  required_providers {
    akamai = {
      source = "akamai/akamai"
      version = "1.4.0"
    }
  }
}

# Configure the Akamai Provider
provider "akamai" {
  edgerc = "~/.edgerc"
  config_section = "jp"
}

#Rule source
data "local_file" "rules" {
  filename = "rules.json"
}

data "akamai_contract" "contract" {
}

data "akamai_group" "group" {
  name = "shki"
  contract = data.akamai_contract.contract.id
}

#EdgeDNS CNAME record
resource "akamai_dns_record" "a_record" {
  zone       = "shki.tokyo"
  name       = "terraform01.ff-duma.shki.tokyo"
  recordtype = "CNAME"
  ttl        = "600"
  target     = ["terraform01.ff-duma.shki.tokyo.edgesuite.net."]
}

#EdgeDNS Origin A record
resource "akamai_dns_record" "a_record-origin_hostname" {
  zone       = "shki.tokyo"
  name       = "terraform01-origin.shki.tokyo"
  recordtype = "A"
  ttl        = "600"
  target     = ["13.112.26.181"]
}

#CP code
resource "akamai_cp_code" "cp_code" {
  name     = "shki-terraform01"
  contract = data.akamai_contract.contract.id
  group    = data.akamai_group.group.id
  product  = "prd_Fresca"
}

#DP Edge hostname
resource "akamai_edge_hostname" "edge_hostname" {
  product = "prd_Fresca"
  contract = data.akamai_contract.contract.id
  group    = data.akamai_group.group.id
  edge_hostname = "terraform01.ff-duma.shki.tokyo.edgesuite.net"
}
