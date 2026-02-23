# Changelog - Homelab Project

## [0.2.4] - 2026-02-23 - First Step of Migration Complete & GitHub Mirroring
### Added



## [0.2.3] - 2026-02-19 - The Great Recovery & Hardening
### Added
- Feat: Implemented Cluster-wide SSH Hardening. Disabled password authentication and root login across all nodes.
- Feat: Ansible: Created a "Bootstrap" playbook to standardize new nodes (User creation, Fish shell, Sudoers, SSH keys).
- Feat: Made `install_docker.yml` OS-agnostic (Debian/Ubuntu) and Architecture-aware (x86_64 to amd64 mapping).
- Feat: Automated NFS mounting to `/mnt/NAS_ZFS` with `_netdev` and `nofail` flags to ensure system stability over ZeroTier.

### Fixed
- Critical: Successfully recovered from a rootkit/compromise on `ionos_vps` via a full OS reinstall and immediate Ansible-led hardening.
- Issue: Fixed Ansible connection failures to the new VPS by overriding local SSH config using `-e "ansible_user=root"`.
- Issue: Fixed a potential shell-loop by ensuring `fish` is installed before being assigned as a default shell in Ansible.

### Changed
- Chore: Migrated Seafile configuration to use `blockinfile` with Jinja2, enabling easier SSO (Authentik) integration while preserving generated credentials.


## [0.2.2] - 2026-02-17 - GitOps Refactor, ZeroTier "Darknet" & Homepage Deployment
### Added
- Feat: Deployed Ansible Playbook`deploy_homepage_docker.yml` utilizing a dynamic playbook handoff to `deploy_caddy.yml` for fully automated, zero-downtime reverse proxy routing.
- Feat: Fully finished and implemented a "Darknet" ZeroTier overlay architecture. Internal services (`*.potterman.party`) now route exclusively over encrypted `192.168.192.x` tunnels without requiring public port forwarding. (It was that way before, now it's just standardized and in files)
- Feat: Refactored the local Git sync script (`sync.sh`) on the deployment server to be branch-agnostic, safely supporting isolated `staging` environments. Note, this is the first step towards creating `production` and `testing` environments down the line.

### Changed
- Chore: Refactored `Caddyfile` into a GitOps-compliant Jinja2 template (`Caddyfile.j2`), dynamically mapping host targets using Ansible's `zerotier_ip` inventory variables.
- Chore: Removed redundant Ansible Cloudflare DNS tasks, fully relying on the established Wildcard (`*`) A-record for all internal proxy routing.

### Fixed
- Issue: Resolved an Ansible/Caddy validation crash by explicitly injecting the vaulted `CLOUDFLARE_API_TOKEN` into the temporary execution environment during the `caddy validate` template check.
- Issue: Fixed Caddy syntax validation logic by appending `--adapter caddyfile` to the Ansible template check command.

## [0.2.1] - 2026-02-17 - Cloud Expansion & Teamspeak Deployment
### Added
- Feat: Provisioned an IONOS VPS and successfully joined it to the ZeroTier mesh network (`192.168.192.58`).
- Feat: Created Ansible playbook (`deploy_teamspeak6_server.yml`) to fully automate Cloudflare DNS A-record creation, Docker engine installation, and TeamSpeak container deployment.
- Docs: Added troubleshooting notes for IONOS Hardware Firewall blocking external traffic by default.
- Feat: Created first draft of Ansible playbook (`baseline_setup_workstation.yml`) to make sure that all the hosts in the network have identical packages, environments, permissions, accounts etc.

### Fixed
- Issue: Ansible `apt update` failures on `pve` caused by expired Cloudsmith/xcaddy GPG keys, duplicate `pve-no-subscription` repos, and lingering enterprise lists.
- Issue: Ansible `apt update` failures on `debian-docker` caused by missing GPG key for Fish Shell release 4.
- Issue: `ansible-lint` warnings regarding missing `pipefail` on shell commands.
- Issue: Docker API `permission denied` errors on the VPS by ensuring the `potterman` user is appended to the `docker` group via Ansible.
- Issue: TeamSpeak log `grep` permission errors by properly recursing `/opt/teamspeak` volume ownership to UID/GID `9987`.

### Security/Maintenance
- Chore: Identified IONOS Cloud Panel hardware firewall requirements for UDP 9987 and TCP 30033; manual change for now, to be automated properly with token access later on.

## [0.2.0] - 2026-02-16 - Infrastructure Foundation, VPS, Ansible Vault and First Automation
### Added
- Feat: Deployed a centralized **Caddy Reverse Proxy** on the Proxmox Host (`192.168.2.100`) to act as the primary traffic router for the Homelab.
- Feat : Implemented **Wildcard DNS routing** (`*.potterman.party`) via Cloudflare pointing to the Proxmox Caddy instance, eliminating the need to create manual A-records for future internal services.
- Feat: Successfully implemented **Ansible Vault** (`ansible-vault`). Cloudflare API tokens are now encrypted at rest and injected directly into Caddy's systemd environment securely at runtime.
- Feat (Ansible): Created `deploy_caddy.yml` playbook. It downloads the custom Caddy binary (with the Cloudflare DNS plugin), pushes the configuration, and manages the systemd service.

### Changed
- Chore: Completely restructured `ansible/inventory/inventory.yaml` to perfectly map the physical `192.168.2.x` topology using nested YAML groups (`homelab`, `proxmox`, `virtual_machines`, `lxc_containers`).
- Chore: Refactored the `Caddyfile` to use DRY (Don't Repeat Yourself) snippets (`import cloudflare_tls`) for ACME challenges, drastically reducing configuration bloat.
- Fix: Mapped the Forgejo reverse proxy correctly through Caddy, resolving local DNS resolution requirements.

### Fixed
- Issue: Diagnosed and fixed a ghost "Disk Full" error on the Pi-hole container caused by a saturated `/dev/shm` (Shared Memory) partition.
- Issue: Playbook vault variable not getting passed correctly. Resolved by formatting the playbook as it was supposed to.
- Issue: Resolved a Vault decryption mismatch by aligning `ansible.cfg` directory context with the `.ansible_vault_pass` file.
- Issue: Fixed a YAML dictionary parsing error (`_AnsibleTaggedStr`) inside the encrypted vault file.
- Issue: Resolved a Let's Encrypt `Expected 1 zone, got 0` error by correctly scoping the Cloudflare API Token permissions to **Specific Zone: potterman.party.
- Issue: Fixed a "context canceled" / "stale lock" race condition during initial certificate generation by implementing a clean state-wipe protocol.

## [0.1.0] - 2026-01-28 - GitOps Foundation & Workspace Optimization
### Added
- Feat: Initialized Ansible inventory.yaml with 4 hosts.
- Docs: Added `cachyos.md` to Troubleshooting section to add resolutions for host problems.
- Feat: New tasks regarding Kubernetes, S3, IaC and AWS setups added to Phase 2 roadmap.
- Feat: Added `content.code.annotate` to `mkdocs.yml` for future use.

### Fixed
- Issue: CachyOS hangs for 90 seconds during shutdown sequence.
- Issue: Asymmetric Routing / Gateway Conflict (ZeroTier)

### Changed
- Chore: Refactored Zellij layout to use SSH aliases for better portability across different workstation hosts.
- Chore: Refactored starship theme to use in Alacritty.
- Chore: Fixed formatting of `forgejo.md` and `hardware.md`.

### Security/Maintenance
- Chore: Forgejo labels for easier Issue organization.
- Chore: Forgejo Milestones.
- Feat: Releases in the "Release" section of the repository.
- Performed ZFS pool integrity check; `zpool status` confirmed 0 errors on primary storage.
- Audit: Performed security check using `git log -p | grep -Ei "password|token|secret|api_key"` to find any possible leaks in the `homelab` and `docker-compose` repos. None found.
- Docs: Added `hardware.md` to Troubleshooting. Hardware related Issues and Fixes.
- Docs: Added Issue: 27.3k write errors when `zpool status` was invoked on the PVE. `hardware.md`
- Docs: Added `cachyos.md` and `network.md` to the Troubleshooting documentation.
- Docs: Issue: CachyOS hangs for 90 seconds during shutdown sequence.
- Docs: Issue: Asymmetric Routing / Gateway Conflict (ZeroTier)


## [0.0.2] - 2026-01-28 - Documentation, Workstation and ZFS woes
### Added
- Feat: Zellij Dashboard layout with PVE/Docker/OMV/Ansible/CachyOS tabs. 
- Feat: Phase 1-6 Roadmap initialization. `./ROADMAP.md`
- Docs: Initial Network Graph via /infrastructure/network.md using Mermaid.js
- Feat: `CHANGELOG.md` is now functional
- Docs: Updated `renovate.md` and `forgejo.md` with the recent issues and fixes.

### Fixed
- Issue: Forgejo SSH authentication (Port 2222 vs 22 conflict).
- Issue: Repository sync warnings via Admin Operations.

### Security/Maintenance
- Critical/Fixed: 27.3k write errors when `zpool status` was invoked on the PVE.

## [0.0.1] - 2026-01-25 - The Foundation

### Added
- Feat: Initialized Project Homelab.
- Docs: Initialized MkDocs to serve as a documentation for the Project.
- Docs: Added initial set of rules in Git documentation.
- Docs: Added `/troubleshooting/forgejo.md` for documenting Issues and Fixes
- Docs: Added `/troubleshooting/renovate.md` for documenting Issues and Fixes

### Fixed
- Issue: Error 401, Token Unauthorized
- Issue: actions/checkout@v6 fails with "got node24"
- Issue: 'GITHUB' in the secret name