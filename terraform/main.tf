resource "proxmox_virtual_environment_pool" "backup_all_vm" {
  pool_id = "backup_all_vm"
  comment = "Managed by Terraform"
}
module "ansible_hub" {
  source = "./modules/proxmox-lxc"

  vm_id        = 105
  hostname     = "ansible-main"
  ipv4_address = "192.168.2.105/24"
  dedicated    = 4096
  cores        = 2
  tags         = ["ansible", "proxmox", "terraform", "vm"]
}
module "k3s_node_01" {
  source = "./modules/proxmox-vm"

  hostname     = "k3s-01"
  ipv4_address = "192.168.2.201/24"
  vm_id        = 201
  dedicated    = 4096
  floating     = 4096
  size         = 30
  tags         = ["proxmox", "terraform", "vm", "k3"]
}
