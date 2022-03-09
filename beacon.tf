variable "beacon_wireguard_class_c_subnet" {
  type = string
  description = "the first 3 octets of the beacon's wireguard ipv4 address. eg 192.168.1"
  default = "10.10.0"
}

variable "beacon_wireguard_last_octet" {
  type = string
  description = "the last octet of the beacon's wireguard ipv4"
  default  = "1"
}

locals {
  beacon_wireguard_peers = [{
    name = "satellite"
    public_key = "${var.satellite_wireguard_public_key}"
    allowed_ips = "${var.beacon_wireguard_class_c_subnet}.${var.satellite_wireguard_last_octet}/32"
    keepalive = 21
  }]
}

data "template_file" "beacon_wireguard_peers" {
  template = file("${path.module}/templates/peer.tmpl")
  count = length(local.beacon_wireguard_peers)
  vars = {
    name = local.beacon_wireguard_peers[count.index].name
    public_key = local.beacon_wireguard_peers[count.index].public_key
    allowed_ips = local.beacon_wireguard_peers[count.index].allowed_ips
    keepalive = local.beacon_wireguard_peers[count.index].keepalive
  }
}

data "template_file" "beacon_wireguard_config" {
  template = file("${path.module}/templates/beacon.tmpl")
  vars = {
    private_key = var.beacon_wireguard_private_key
    port = var.beacon_endpoint_port
    class_c_subnet = var.beacon_wireguard_class_c_subnet
    last_octet = var.beacon_wireguard_last_octet
    peers = join("\n", data.template_file.beacon_wireguard_peers.*.rendered)
  }
}

output "beacon_wireguard_config" { 
  value = data.template_file.beacon_wireguard_config.rendered
}

output "beacon_wireguard_public_key" { 
  value = var.beacon_wireguard_public_key
}