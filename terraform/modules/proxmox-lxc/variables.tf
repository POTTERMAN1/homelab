# DESCRIPTION
variable "description" {
  description = "Description of the resource in Proxmox VE"
  type        = string
  default     = "Managed by Terraform"

}

variable "tags" {
  description = "List of default proxmox LXC tags"
  type        = list(string)
  default     = ["proxmox", "lxc", "terraform", "default"]
}

variable "node_name" {
  description = "Default Node Name"
  type        = string
  default     = "proxmox"
}

variable "vm_id" {
  description = "LXC ID in Proxmox"
  type        = number
  default     = 500

}

variable "pool_id" {
  description = "ID of the pool in which the VM will be in"
  type        = string
  default     = "backup_all_vm"
}

variable "unprivileged" {
  description = "Is this resource unprivileged"
  type        = bool
  default     = true
}

# OPERATING SYSTEM

variable "template_file_id" {
  description = "Default operating system file location"
  type        = string
  default     = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"

}

variable "type" {
  description = "OS Type"
  type        = string
  default     = "debian"

}

# FEATURES

variable "nesting" {
  description = "Boolean, is container nested?"
  type        = bool
  default     = true

}

# CPU CONFIGURATION
variable "cores" {
  description = "Number of CPU cores to use"
  type        = number
  default     = 1

}

# DISK CONFIGURATION
variable "datastore_id" {
  description = "Identifier of the datastore to create the disk in"
  type        = string
  default     = "local-lvm"

}

variable "size" {
  description = "Disk size (in Gigabytes)"
  type        = number
  default     = 20

}
# USER CONFIG
variable "keys" {
  description = "Default list of public SSH keys"
  type        = list(string)
  default = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPtN2ntV0h4uw/Ej4yqkLszk5coARGufSFjU+EdowI2 potterman@potterman",
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/f/cwTIhCxoUeXw/v+mMReH3vrnFCFfRd9B1ksYt76 potterman@ansible-main"]
}

variable "password" {
  description = "Default user password (Initial)"
  type        = string
  default     = "default-password-changeme"

}

# DNS CONFIG
variable "servers" {
  description = "Default DNS Servers"
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]

}

variable "hostname" {
  description = "Default hostname"
  type        = string
  default     = "proxmox-terraform-default-hostname"

}

#IP CONFIGURATION
variable "ipv4_address" {
  description = "Default IP address"
  type        = string
  default     = "192.168.2.200/24"
}

variable "ipv4_gateway" {
  description = "Default gateway"
  type        = string
  default     = "192.168.2.254"

}

# MEMORY CONFIGURATION
variable "dedicated" {
  description = "Ammount of memory (in Megabytes)"
  type        = number
  default     = 2048

}

variable "swap" {
  description = "default ammount of sawp memory (in Megabytes)"
  type        = number
  default     = 512

}

# NETWORK DEVICE

variable "name" {
  description = "Default name of network interface"
  type        = string
  default     = "eth0"

}

variable "firewall" {
  description = "Whether to enable or disable the firewall"
  type        = bool
  default     = true

}

variable "bridge" {
  description = "Default network bridge"
  type        = string
  default     = "vmbr0"

}
