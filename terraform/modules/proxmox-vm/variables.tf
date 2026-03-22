# POOL VARIABLES

variable "pool_id" {
  description = "ID of the pool in which the VM will be in"
  type        = string
  default     = "backup_all_vm"
}

variable "comment" {
  description = "Description of the resource"
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Default tags"
  type        = list(string)
  default     = ["proxmox", "vm", "terraform", "default"]

}

# PROXMOX_VIRTUAL_ENVIRONMENT_VM VARIABLES

variable "pve_node_name" {
  description = "Name of the Proxmox node"
  type        = string
  default     = "proxmox"
}

variable "hostname" {
  description = "Hostname"
  type        = string
  default     = "terraform-debian-13-cloud-vm"

}

variable "template_vm_id" {
  description = "VM ID of the Cloud-Init image"
  type        = number
  default     = 9000

}

variable "vm_id" {
  description = "Default VM ID"
  type        = number
  default     = 200

}

variable "description" {
  description = "VM Description inside Proxmox"
  type        = string
  default     = "Managed by Terraform"

}

variable "on_boot" {
  description = "Whether to launch the VM on boot or not"
  type        = bool
  default     = true

}

# CPU CONFIGURATION
variable "architecture" {
  description = "Architecture of the CPU"
  type        = string
  default     = "x86_64"

}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2

}

#DISK CONFIGURATION
variable "interface" {
  description = "Default disk interface"
  type        = string
  default     = "scsi0"

}

variable "datastore_id" {
  description = "Path to the disk image"
  type        = string
  default     = "local-lvm"

}

variable "size" {
  description = "Size of the disk (in Gigabytes)"
  type        = number
  default     = 20

}

# DNS CONFIGURATION

variable "servers" {
  description = "Default DNS Servers"
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]

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

variable "bridge" {
  description = "Default network bridge"
  type        = string
  default     = "vmbr0"

}

# MEMORY CONFIGURATION

variable "dedicated" {
  description = "Ammount of memory (in Megabytes)"
  type        = number
  default     = 2048

}

variable "floating" {
  description = "Enable or disable 'RAM BAlooning'"
  type        = number
  default     = 2048

}

# USER ACCOUNT

variable "username" {
  description = "username"
  type        = string
  default     = "potterman"

}

variable "keys" {
  description = "Default keys for cloud-init user"
  type        = list(string)
  default = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPtN2ntV0h4uw/Ej4yqkLszk5coARGufSFjU+EdowI2 potterman@potterman",
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/f/cwTIhCxoUeXw/v+mMReH3vrnFCFfRd9B1ksYt76 potterman@ansible-main"]


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
