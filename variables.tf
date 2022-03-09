variable "interface" {
  type = string
  description = "name of the wireguard interface"
}

variable "beacon_endpoint_domain" {
  type = string
  description = "public facing domain or IP of beacon"
}

variable "beacon_endpoint_port" {
  type = string
  description = "port the beacon will listen on"
}

variable "beacon_wireguard_private_key" { 
  type = string
  description = "wireguard private key for beacon"
}

variable "beacon_wireguard_public_key" { 
  type = string
  description = "wireguard public key for beacon"
}

variable "satellite_wireguard_private_key" {
  type = string
  description = "wireguard private key for satellite-1"
}

variable "satellite_wireguard_public_key" {
  type = string
  description = "wireguard public key for satellite-1"
}

