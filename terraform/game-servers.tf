module "pve-pelican-wings-vm-01" {
  source = "./modules/proxmox-vm"

  description = "Pelican Wings node - game servers"
  hostname    = "pve-wings-vm-01"
  vm_id       = 202
  dedicated   = 2048
  floating    = 2048
  size        = 30
  tags        = ["proxmox", "terraform", "vm", "pelican", "wings"]
}
