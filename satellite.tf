variable "satellite_wireguard_last_octet" {
  type = string
  default = "2"
  description = "last octet of satellite's wireguard ipv4 on the beacon subnet"
}

locals {
  satellite_beacon_wireguard_peers = [{
    name = "beacon-beacon"
    public_key = "${var.beacon_wireguard_public_key}"
    allowed_ips = "${var.beacon_wireguard_class_c_subnet}.${var.beacon_wireguard_last_octet}/32"
    keepalive = 21
    endpoint = "${var.beacon_endpoint_domain}:${var.beacon_endpoint_port}"
  }]
}

data "template_file" "satellite_beacon_wireguard_peers" {
  template = file("${path.module}/templates/peer-endpoint.tmpl")
  count = length(local.satellite_beacon_wireguard_peers)
  vars = {
    name = local.satellite_beacon_wireguard_peers[count.index].name
    public_key = local.satellite_beacon_wireguard_peers[count.index].public_key
    allowed_ips = local.satellite_beacon_wireguard_peers[count.index].allowed_ips
    keepalive = local.satellite_beacon_wireguard_peers[count.index].keepalive
    endpoint = local.satellite_beacon_wireguard_peers[count.index].endpoint
  }
}

data "template_file" "satellite_wireguard_config" {
  template = file("${path.module}/templates/satellite.tmpl")
  vars = {
    private_key = var.satellite_wireguard_private_key
    class_c_subnet = var.beacon_wireguard_class_c_subnet
    last_octet = var.satellite_wireguard_last_octet
    peers = join("\n", data.template_file.satellite_beacon_wireguard_peers.*.rendered)
  }
}

output "satellite_wireguard_config" { 
  value = data.template_file.satellite_wireguard_config.rendered
}

output "satellite_wireguard_public_key" { 
  value = var.satellite_wireguard_public_key
}