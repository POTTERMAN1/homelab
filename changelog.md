# Changelog - Homelab Project

## [Unreleased]

## [0.3.2] - 2026-03-21 - Terraform Modules, K3s & Kubernetes Object Storage

### Added

- Created reusable Terraform module `modules/proxmox-vm` for VM provisioning via cloud-init templates, with configurable CPU, memory, disk, networking, and SSH key injection.
- Created reusable Terraform module `modules/proxmox-lxc` for LXC container provisioning with the same modular variable pattern.
- Built a Debian 13 (Trixie) cloud-init VM template (ID 9000) on Proxmox for standardized VM provisioning.
- Provisioned `k3s-01` (VM 201, `192.168.2.201`) using the new Terraform VM module — first VM deployed entirely through IaC.
- Installed K3s (Kubernetes) on `k3s-01`, establishing the cluster's first control-plane node.
- Deployed **Garage** (S3-compatible object storage) on Kubernetes using hand-written manifests: Namespace, Secret, ConfigMap, PersistentVolume, PersistentVolumeClaim, Deployment, and Service (NodePort).
- Garage backed by NAS storage via hostPath (`/mnt/NAS_ZFS/garage-data`) with metadata on local SSD (`/var/lib/garage/meta`).
- Added `k3s-01` to Ansible inventory and applied the `common` hardening role.
- Added Caddy reverse proxy entry for `s3.potterman.party` routing to Garage's K3s NodePort (30900).
- Updated roadmap with Azure, Kubernetes, and expanded CI/CD pipeline tasks.

### Changed

- Upgraded `bpg/proxmox` Terraform provider from `0.93.0` to `~> 0.98`.
- Migrated Terraform provider authentication from SSH-only to API token-based auth with sensitive variable handling via `terraform.tfvars`.
- Resolved Terraform state drift on `ansible_hub` container (memory 1024→4096, CPU block alignment) to prevent unintended in-place modifications.

### Fixed

- Terraform module provider resolution failing due to missing `required_providers` block in child modules (defaulting to `hashicorp/proxmox` instead of `bpg/proxmox`).
- Terraform API token permission error (`Pool.Audit`) resolved by correcting privilege separation settings on the Proxmox API token.
- Cloud-init SSH key update on running K3s VM failing with `ide2: hotplug problem` — resolved by stopping the VM before applying cloud-init changes.

## [0.3.1] - 2026-03-16 - FoundryVTT, Firefly III & Structural Refactor

### Added

- Deployed **FoundryVTT** on `debian-docker` using a custom-built Docker image with a multi-arg Dockerfile (Node.js 22-slim base, version-pinned build via `ARG`, `.dockerignore` whitelist, custom healthcheck script).
- FoundryVTT user data served from NAS via NFS mount (`/mnt/NAS_ZFS/foundry_user_data`) to offload 12GB+ of world data from local disk.
- Deployed **Firefly III** (budget tracking) on `debian-docker` with Authentik SSO integration via Caddy `forward_auth` directive.
- Created centralized `services.yml` for application service variables, replacing scattered variable definitions across individual role files.
- Added Caddy reverse proxy entries for `foundry.potterman.party` and `firefly.potterman.party`.

### Changed

- Refactored Ansible role directory from `ansible/playbooks/roles/` to `ansible/roles/` to follow community conventions and resolve VSCode/ansible-lint path resolution warnings.
- Updated `ansible.cfg` — changed `roles_path` to `./roles`, removed `playbook_dir` directive.
- Migrated role variable references in `authentik`, `homepage`, and `seafile` tasks to use the new `app_services` variable structure from `services.yml`.
- Removed old Terraform provider binaries and VSCode workspace files from repository.
- FoundryVTT Caddy route updated from `cachy-os` ZeroTier IP to `debian-docker` ZeroTier IP.

### Fixed

- FoundryVTT Docker healthcheck failing with HTTP 302 — resolved by accepting 2xx and 3xx status codes as healthy responses.
- `debian-docker` disk full (29GB/30GB) during Docker image build — resolved by pruning unused images and build cache (`docker system prune -a`).
- Fixed variable naming inconsistencies between Dockerfile `--dataPath`, compose volume mounts, and Ansible task directory names.

## [0.3.0] - 2026-02-23 - Role Refactor & CI/CD Pipelines

### Added

- Created `.forgejo/workflows/ci-lint.yml` to automatically run `yamllint` and `ansible-lint` against the `staging` branch.
- Integrated Ansible Vault securely into the Forgejo runner using `ANSIBLE_VAULT_PASS` repository secrets to allow dynamic linting.
- Created `.forgejo/workflows/mirror.yml` to automatically push the `main` branch to a GitHub mirror repository.
- Created `.github/workflows/deploy-docs.yml` to automatically build and deploy the MkDocs documentation to GitHub Pages.
- Added documentation for Terraform's role in provisioning the initial `ansible-main` control node on Proxmox.

### Changed

- Executed a massive architectural refactor, converting flat playbooks into isolated Ansible Roles (`common`, `caddy`, `docker`, `seafile`, `authentik`, `homepage`, `teamspeak`).
- Renamed role variables (e.g., `common_zt_join`, `docker_user_group_check`) across all playbooks to strictly adhere to `ansible-lint` best practices and avoid variable collisions.
- Caddy reverse proxy now dynamically routes traffic strictly through the ZeroTier mesh IPs using Ansible's `hostvars` dictionary.

## [0.2.3] - 2026-02-19 - The Great Recovery & Hardening

### Added

- Implemented Cluster-wide SSH Hardening. Disabled password authentication and root login across all nodes.
- Ansible: Created a "Bootstrap" playbook to standardize new nodes (User creation, Fish shell, Sudoers, SSH keys).
- Made `install_docker.yml` OS-agnostic (Debian/Ubuntu) and Architecture-aware (x86_64 to amd64 mapping).
- Automated NFS mounting to `/mnt/NAS_ZFS` with `_netdev` and `nofail` flags to ensure system stability over ZeroTier.

### Fixed

- Critical: Successfully recovered from a rootkit/compromise on `ionos_vps` via a full OS reinstall and immediate Ansible-led hardening.
- Fixed Ansible connection failures to the new VPS by overriding local SSH config using `-e "ansible_user=root"`.
- Fixed a potential shell-loop by ensuring `fish` is installed before being assigned as a default shell in Ansible.

### Changed

- Migrated Seafile configuration to use `blockinfile` with Jinja2, enabling easier SSO (Authentik) integration while preserving generated credentials.

## [0.2.2] - 2026-02-17 - GitOps Refactor, ZeroTier "Darknet" & Homepage Deployment

### Added

- Deployed Ansible Playbook`deploy_homepage_docker.yml` utilizing a dynamic playbook handoff to `deploy_caddy.yml` for fully automated, zero-downtime reverse proxy routing.
- Fully finished and implemented a "Darknet" ZeroTier overlay architecture. Internal services (`*.potterman.party`) now route exclusively over encrypted `192.168.192.x` tunnels without requiring public port forwarding. (It was that way before, now it's just standardized and in files)
- Refactored the local Git sync script (`sync.sh`) on the deployment server to be branch-agnostic, safely supporting isolated `staging` environments. Note, this is the first step towards creating `production` and `testing` environments down the line.

### Changed

- Refactored `Caddyfile` into a GitOps-compliant Jinja2 template (`Caddyfile.j2`), dynamically mapping host targets using Ansible's `zerotier_ip` inventory variables.
- Removed redundant Ansible Cloudflare DNS tasks, fully relying on the established Wildcard (`*`) A-record for all internal proxy routing.

### Fixed

- Resolved an Ansible/Caddy validation crash by explicitly injecting the vaulted `CLOUDFLARE_API_TOKEN` into the temporary execution environment during the `caddy validate` template check.
- Fixed Caddy syntax validation logic by appending `--adapter caddyfile` to the Ansible template check command.

## [0.2.1] - 2026-02-17 - Cloud Expansion & Teamspeak Deployment

### Added

- Provisioned an IONOS VPS and successfully joined it to the ZeroTier mesh network (`192.168.192.58`).
- Created Ansible playbook (`deploy_teamspeak6_server.yml`) to fully automate Cloudflare DNS A-record creation, Docker engine installation, and TeamSpeak container deployment.
- Added troubleshooting notes for IONOS Hardware Firewall blocking external traffic by default.
- Created first draft of Ansible playbook (`baseline_setup_workstation.yml`) to make sure that all the hosts in the network have identical packages, environments, permissions, accounts etc.

### Fixed

- Ansible `apt update` failures on `pve` caused by expired Cloudsmith/xcaddy GPG keys, duplicate `pve-no-subscription` repos, and lingering enterprise lists.
- Ansible `apt update` failures on `debian-docker` caused by missing GPG key for Fish Shell release 4.
- `ansible-lint` warnings regarding missing `pipefail` on shell commands.
- Docker API `permission denied` errors on the VPS by ensuring the `potterman` user is appended to the `docker` group via Ansible.
- TeamSpeak log `grep` permission errors by properly recursing `/opt/teamspeak` volume ownership to UID/GID `9987`.

### Security/Maintenance

- Identified IONOS Cloud Panel hardware firewall requirements for UDP 9987 and TCP 30033; manual change for now, to be automated properly with token access later on.

## [0.2.0] - 2026-02-16 - Infrastructure Foundation, VPS, Ansible Vault and First Automation

### Added

- Deployed a centralized **Caddy Reverse Proxy** on the Proxmox Host (`192.168.2.100`) to act as the primary traffic router for the Homelab.
- Implemented **Wildcard DNS routing** (`*.potterman.party`) via Cloudflare pointing to the Proxmox Caddy instance, eliminating the need to create manual A-records for future internal services.
- Successfully implemented **Ansible Vault** (`ansible-vault`). Cloudflare API tokens are now encrypted at rest and injected directly into Caddy's systemd environment securely at runtime.
- Ansible): Created `deploy_caddy.yml` playbook. It downloads the custom Caddy binary (with the Cloudflare DNS plugin), pushes the configuration, and manages the systemd service.

### Changed

- Completely restructured `ansible/inventory/inventory.yaml` to perfectly map the physical `192.168.2.x` topology using nested YAML groups (`homelab`, `proxmox`, `virtual_machines`, `lxc_containers`).
- Refactored the `Caddyfile` to use DRY (Don't Repeat Yourself) snippets (`import cloudflare_tls`) for ACME challenges, drastically reducing configuration bloat.
- Fix: Mapped the Forgejo reverse proxy correctly through Caddy, resolving local DNS resolution requirements.

### Fixed

- Diagnosed and fixed a ghost "Disk Full" error on the Pi-hole container caused by a saturated `/dev/shm` (Shared Memory) partition.
- Playbook vault variable not getting passed correctly. Resolved by formatting the playbook as it was supposed to.
- Resolved a Vault decryption mismatch by aligning `ansible.cfg` directory context with the `.ansible_vault_pass` file.
- Fixed a YAML dictionary parsing error (`_AnsibleTaggedStr`) inside the encrypted vault file.
- Resolved a Let's Encrypt `Expected 1 zone, got 0` error by correctly scoping the Cloudflare API Token permissions to \*\*Specific Zone: potterman.party.
- Fixed a "context canceled" / "stale lock" race condition during initial certificate generation by implementing a clean state-wipe protocol.

## [0.1.0] - 2026-01-28 - GitOps Foundation & Workspace Optimization

### Added

- Initialized Ansible inventory.yaml with 4 hosts.
- Added `cachyos.md` to Troubleshooting section to add resolutions for host problems.
- New tasks regarding Kubernetes, S3, IaC and AWS setups added to Phase 2 roadmap.
- Added `content.code.annotate` to `mkdocs.yml` for future use.

### Fixed

- CachyOS hangs for 90 seconds during shutdown sequence.
- Asymmetric Routing / Gateway Conflict (ZeroTier)

### Changed

- Refactored Zellij layout to use SSH aliases for better portability across different workstation hosts.
- Refactored starship theme to use in Alacritty.
- Fixed formatting of `forgejo.md` and `hardware.md`.

### Security/Maintenance

- Forgejo labels for easier rganization.
- Forgejo Milestones.
- Releases in the "Release" section of the repository.
- Performed ZFS pool integrity check; `zpool status` confirmed 0 errors on primary storage.
- Audit: Performed security check using `git log -p | grep -Ei "password|token|secret|api_key"` to find any possible leaks in the `homelab` and `docker-compose` repos. None found.
- Added `hardware.md` to Troubleshooting. Hardware related and Fixes.
- Added 27.3k write errors when `zpool status` was invoked on the PVE. `hardware.md`
- Added `cachyos.md` and `network.md` to the Troubleshooting documentation.
- CachyOS hangs for 90 seconds during shutdown sequence.
- Asymmetric Routing / Gateway Conflict (ZeroTier)

## [0.0.2] - 2026-01-28 - Documentation, Workstation and ZFS woes

### Added

- Zellij Dashboard layout with PVE/Docker/OMV/Ansible/CachyOS tabs.
- Phase 1-6 Roadmap initialization. `./ROADMAP.md`
- Initial Network Graph via /infrastructure/network.md using Mermaid.js
- `CHANGELOG.md` is now functional
- Updated `renovate.md` and `forgejo.md` with the recent and fixes.

### Fixed

- Forgejo SSH authentication (Port 2222 vs 22 conflict).
- Repository sync warnings via Admin Operations.

### Security/Maintenance

- Critical/Fixed: 27.3k write errors when `zpool status` was invoked on the PVE.

## [0.0.1] - 2026-01-25 - The Foundation

### Added

- Initialized Project Homelab.
- Initialized MkDocs to serve as a documentation for the Project.
- Added initial set of rules in Git documentation.
- Added `/troubleshooting/forgejo.md` for documenting and Fixes
- Added `/troubleshooting/renovate.md` for documenting and Fixes

### Fixed

- Error 401, Token Unauthorized
- actions/checkout@v6 fails with "got node24"
- 'GITHUB' in the secret name
