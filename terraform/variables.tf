variable "node_id" {
  description = "ID for the node and the last octet of its IP address"
  type        = number
  default     = 105
}

variable "pve_node_name" {
  description = "PVE hostname"
  type        = string
  default     = "proxmox"
}

variable "ssh_public_key" {
  description = "Public SSH key from CachyOS host"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPtN2ntV0h4uw/Ej4yqkLszk5coARGufSFjU+EdowI2 potterman@potterman"

}


variable "proxmox_ve_endpoint" {
  description = "Proxmox VE API endpoint URL"
  type        = string
  sensitive   = true
}

variable "proxmox_api_token" {
  description = "Proxmox VE API Token"
  type        = string
  sensitive   = true
}
