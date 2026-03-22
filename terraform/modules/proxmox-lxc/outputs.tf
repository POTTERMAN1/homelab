output "vm_id" {
  value = proxmox_virtual_environment_vm.vm.vm_id
}

output "ipv4_address" {
  value = "192.168.2.${var.vm_id}"
}
