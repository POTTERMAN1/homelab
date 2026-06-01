module "pve-pelican-wings-vm-01" {
  source = "./modules/proxmox-vm"

  description  = "Pelican Wings node - game servers"
  hostname     = "pve-wings-vm-01"
  ipv4_address = "192.168.2.202/24"
  vm_id        = 202
  dedicated    = 4096
  floating     = 4096
  size         = 30
  tags         = ["proxmox", "terraform", "vm", "pelican", "wings"]
}
