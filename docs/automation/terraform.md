## 🏗️ Infrastructure Provisioning (Terraform)

While Ansible handles the configuration management and software deployment, **Terraform** is utilized for the foundational hardware provisioning. 

Currently, Terraform is used to bootstrap the core management layer—specifically, provisioning the `ansible-main` control node directly on the Proxmox (PVE) host. This ensures the management plane is defined entirely as code from day zero.

**Future Scope:** In upcoming phases, Terraform's responsibilities will be expanded to provision all virtual machines, LXC containers, and network bridges across the Proxmox environment prior to Ansible taking over the software configuration.