# Security Posture & Hardening

Security in this infrastructure is applied in layers, from encrypted variables at rest to strict OS-level authentication policies.

## Secrets Management (Ansible Vault)
No passwords, API tokens, or sensitive variables are stored in plaintext. 

* **Encryption at Rest:** All sensitive strings are encrypted using `ansible-vault` (AES256).
* **Decryption at Runtime:** During CI/CD pipelines, the vault password is injected dynamically into the ephemeral runner via Forgejo/GitHub repository secrets.
* **Service Injection:** Passwords are never written to disk in plaintext. Ansible injects them directly into Docker `.env` files or systemd environments during deployment.

## OS & SSH Hardening
The `common` Ansible role enforces strict baseline security on all newly provisioned nodes before any software is installed:

1. **Root Login Disabled:** `PermitRootLogin no` is strictly enforced across the cluster.
2. **Password Authentication Disabled:** `PasswordAuthentication no` is enforced. Only Ed25519 SSH keys are accepted.
3. **Sudoers Restrictions:** Passwordless sudo is strictly scoped via `/etc/sudoers.d/` drops to dedicated administration accounts.

## Surface Area Reduction
* **No Exposed Ports:** By utilizing the ZeroTier mesh and a single reverse proxy entry point, the internal cluster nodes (Docker hosts, databases) have zero ports exposed to the public internet or the physical LAN.
ONLY EXCEPTION TO THE RULE IS THE TEAMSPEAK 6 SERVER


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