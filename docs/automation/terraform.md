# Terraform Provisioning

Before Ansible can configure the operating systems and deploy Docker containers, the underlying virtual machines and LXC containers must exist. In this infrastructure, all bare-metal provisioning on the Proxmox cluster is handled by **Terraform**.

## The Provider
I utilize the `bpg/proxmox` provider to interact with the Proxmox Virtual Environment API. This allows for declarative definitions of CPU cores, memory allocation, and network bridges.

```hcl
--8<-- "terraform/provider.tf" 
```

## Infrastructure Definition (main.tf)

The main.tf file acts as the blueprint for the virtual environment. It handles cloning from base templates, resizing disks, and injecting the initial SSH keys via Cloud-Init so that Ansible can immediately take over once the machine boots.

Here is the live configuration for the cluster nodes (only ansible-main node for now):
```hct
--8<-- "terraform/main.tf"
```

