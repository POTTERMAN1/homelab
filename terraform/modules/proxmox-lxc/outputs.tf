output "vm_id" {
  value = proxmox_virtual_environment_container.lxc.vm_id
}

output "ipv4_address" {
  value = "192.168.2.${var.vm_id}"
}
