terraform {
  required_version = ">=1.14"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.98"
    }
  }
}
provider "proxmox" {
  endpoint  = var.proxmox_ve_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
}
