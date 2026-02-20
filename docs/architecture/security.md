# Security

### SSH Hardening & Security Standards

To secure the cluster against brute-force attacks and unauthorized access, a unified security policy has been enforced via Ansible across all nodes.

## Policy Implementation:
- **Password Authentication:** Disabled. All SSH access now requires a valid SSH private key.
- **Root Login:** Disabled. `PermitRootLogin no` is enforced to prevent direct administrative access via SSH.
- **Default User:** The user `potterman` is the primary administrative account with `passwordless sudo privileges`.
- **Validation:** All SSH configuration changes are validated using sshd -t before the service restarts to prevent accidental lockouts.



# Incident Report: IONOS VPS Compromise & Recovery

## Incident Description
**Date:** 2026-02-19  
**Issue:** A security compromise was detected on the `ionos_vps`. The attacker utilized an `ld.so.preload` rootkit injection to maintain persistence and hide processes. Crypto Miner was also deployed which spiked the CPU usage and crashed the SSH.

## Resolution Steps
1. **Nuke and Pave:** A full OS re-installation (Debian 13) was performed via the IONOS control panel.
2. **Bootstrap Recovery:** Used Ansible to immediately apply the hardening policy (SSH keys, disabled passwords) before exposing the server to the public internet.
3. **Connection Fix:** Overcame initial SSH connection failures to the fresh "root" account by using the `-e "ansible_user=root"` extra variable to bypass local SSH config defaults that were looking for the `potterman` user.

## Lessons Learned
* Always apply the Ansible hardening playbook immediately after a fresh OS install.
* Do not leave the default `root` password active for longer than the time it takes to push SSH keys.
* Do not forget about disabling `root` access. I'm glad this was an isolated VPS and not my personal PC.