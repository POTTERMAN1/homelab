resource "proxmox_virtual_environment_pool" "backup_all_vm" {
  pool_id = "backup_all_vm"
  comment = "Managed by Terraform"
}

resource "proxmox_virtual_environment_container" "ansible_hub" {
  description  = "Managed by Terraform"
  pool_id      = proxmox_virtual_environment_pool.backup_all_vm.id
  node_name    = var.pve_node_name
  vm_id        = var.node_id
  unprivileged = true

  initialization {
    hostname = "ansible-main"

    ip_config {
      ipv4 {
        address = "192.168.2.${var.node_id}/24"
        gateway = "192.168.2.254"
      }
    }

    user_account {
      keys     = [var.ssh_public_key]
      password = "temporary-password"
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    type             = "debian"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 20

  }

  features {
    nesting = true
  }

  memory {
    dedicated = 1024
  }
  provisioner "remote-exec" {
    inline = [
      "apt-get update && apt-get install -y sudo",
      "useradd -m -s /bin/bash potterman",
      "mkdir -p /home/potterman/.ssh",
      "echo '${var.ssh_public_key}' > /home/potterman/.ssh/authorized_keys",
      "chown -R potterman:potterman /home/potterman/.ssh",
      "chmod 700 /home/potterman/.ssh",
      "chmod 600 /home/potterman/.ssh/authorized_keys",
      "echo 'potterman ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/potterman"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      host        = "192.168.2.${var.node_id}"
      private_key = file("~/.ssh/id_ed25519")
      agent       = false
    }

  }
}
