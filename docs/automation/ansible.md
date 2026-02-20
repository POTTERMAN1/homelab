# Ansible Playbooks & Documentation

### Ansible "Bootstrap" & Workstation Setup
Version 1 of the `baseline_setup_workstation.yml` was created to standardize the environment across all virtual and physical hosts in the network.

## Current Automation Flow:
- **Package Management:** Installs essential utilities including fish, sudo, ufw, htop, nvim and nfs-common.
- **User Provisioning:** Automatically creates the `potterman` user, sets `fish as the default shell`, and populates `~/.ssh/authorized_keys` with multiple administrative keys.
- **Sudo Configuration:** Injects a custom sudoers file into `/etc/sudoers.d/` allowing `potterman` to perform administrative tasks without a password prompt.
- **Docker Agnosticism:** The `install_docker.yml` task was upgraded to handle both Debian and Ubuntu distributions and automatically maps system architectures (e.g., x86_64) to the correct APT format (amd64).