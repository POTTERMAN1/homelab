resource "proxmox_virtual_environment_vm" "vm" {
  vm_id       = var.vm_id
  name        = var.hostname
  description = var.description
  tags        = var.tags

  clone {
    datastore_id = var.datastore_id
    node_name    = var.pve_node_name
    vm_id        = var.template_vm_id
  }

  cpu {
    cores = var.cores
  }

  disk {
    interface    = var.interface
    datastore_id = var.datastore_id
    size         = var.size
  }

  initialization {
    datastore_id = var.datastore_id
    dns {
      servers = var.servers
    }
    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }
    user_account {
      keys     = var.keys
      username = var.username
    }
  }
  memory {
    dedicated = var.dedicated
    floating  = var.floating
  }

  network_device {
    bridge = var.bridge
  }
  node_name = var.pve_node_name
  pool_id   = var.pool_id
}
