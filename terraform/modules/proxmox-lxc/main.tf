resource "proxmox_virtual_environment_container" "lxc" {

  description  = var.description
  node_name    = var.node_name
  tags         = var.tags
  pool_id      = var.pool_id
  vm_id        = var.vm_id
  unprivileged = var.unprivileged

  operating_system {
    template_file_id = var.template_file_id
    type             = var.type
  }

  features {
    nesting = var.nesting
  }

  cpu {
    cores = var.cores
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.size
  }
  initialization {
    dns {
      servers = var.servers
    }
    hostname = var.hostname
    ip_config {
      ipv4 {
        address = "192.168.2.${var.vm_id}/24"
        gateway = var.ipv4_gateway
      }
    }
    user_account {
      keys     = var.keys
      password = var.password
    }
  }
  memory {
    dedicated = var.dedicated
    swap      = var.swap
  }

  network_interface {
    name     = var.name
    firewall = var.firewall
    bridge   = var.bridge
  }
}


