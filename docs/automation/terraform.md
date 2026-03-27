# Terraform Provisioning

Before Ansible can configure the operating systems and deploy Docker containers, the underlying virtual machines and LXC containers must exist. In this infrastructure, all provisioning on the Proxmox cluster is handled by **Terraform** using the `bpg/proxmox` provider (v0.98).

## The Provider

The provider connects to the Proxmox VE API using token-based authentication. Sensitive credentials (endpoint URL and API token) are stored in `terraform.tfvars` which is gitignored.

```hcl
--8<-- "terraform/provider.tf" 
```

## Reusable Modules

Terraform code is organized into reusable modules to avoid duplication and standardize deployments:

### `modules/proxmox-vm`

Provisions full Virtual Machines by cloning a **Debian 13 cloud-init template** (ID 9000). Cloud-init handles initial user creation, SSH key injection, IP assignment, and DNS configuration at boot - allowing Ansible to connect immediately.

Key features: configurable CPU, memory, disk size, and network settings via variables with sensible defaults. The IP address is automatically derived from the VM ID (`192.168.2.${vm_id}/24`).

### `modules/proxmox-lxc`

Provisions lightweight LXC containers from Debian templates. Same variable-driven pattern as the VM module but uses `proxmox_virtual_environment_container` instead.

## Infrastructure Definition (main.tf)

The root `main.tf` calls the modules to provision specific nodes. Currently managed resources:

* **`ansible_hub`** (LXC, ID 105) - the Ansible control node (standalone resource, pending module migration)
* **`k3s_node_01`** (VM, ID 201) - Kubernetes node provisioned via the `proxmox-vm` module

```hcl
--8<-- "terraform/main.tf"
```

## Cloud-Init Template

VM provisioning relies on a Debian 13 cloud-init template (ID 9000) created on the Proxmox host. The template was built by importing the official Debian cloud image (`debian-13-generic-amd64-daily.qcow2`), attaching a cloud-init drive, and converting to a template. This is a one-time manual process documented in the troubleshooting section.

## Known Technical Debt

* The `ansible_hub` LXC container is managed as a standalone resource rather than through the `proxmox-lxc` module. Migrating it via `terraform state mv` was attempted but blocked by attribute drift (password, tags, firewall settings) that would force container recreation. Since this is the active control node running Terraform itself, recreation is high-risk. Documented for future resolution.
