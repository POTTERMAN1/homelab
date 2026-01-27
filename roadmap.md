# 🚀 Project Homelab: Infrastructure & Automation Roadmap

## Phase 1: GitOps Foundation & Workspace Optimization
- [x] **Fix Renovate 401 Error:** Refresh GitHub PAT (repo/read:packages) and update Forgejo secrets.
- [ ] **Forgejo Branching Strategy:** Implement Protected `main` and `staging` branches.
	- [x] homelab repository
	- [ ] docker-compose reposirory
- [x] **Zellij Dashboard:** Create `.kdl` layout with tabs for Ansible, PVE, OMV, and Git logs.
- [ ] **VSCodium Refinement:** Install Ansible/Terraform/YAML extensions + Nerd Fonts.
- [x] **Roadmap as Code:** Move the roadmap into `ROADMAP.md` in the root of the `homelab` repo.
	- [x] Implement `CHANGELOG.md`
	- [ ] Forgejo Issues/Milestones: Use native "Mielstones" to group tasks by Phase
- [ ] **Secrets Management:** Set up **Ansible Vault** for sensitive YAML variables.
- [x] **Documentation Start:** Initialize **Material for MkDocs**.
    - [ ] Build the `docs/architecture.md` using **Mermaid.js** to visualize the flow from CachyOS → Ansible Hub → Managed Nodes.

## Phase 2: Ansible Migration, SSO & Logic

- [ ] **Ansible Hub (.105) Hardening:**
    - [ ] Clone **Homelab** repo to Hub.
    - [ ] Configure `git-sync` or a simple `post-receive` hook to keep CachyOS and Hub in sync via Forgejo.
- [ ] **State & Secret Backend:**
    - [ ] Deploy **MinIO** (S3-compatible storage) on the Docker VM.
    - [ ] Migrate Terraform to a **Remote S3 Backend** (State is now shared between CachyOS/Hub).
- [ ] **Compose-to-Ansible Migration:**
    - [ ] Convert Docker Compose stacks to Ansible `community.docker` modules.
    - [ ] **Logic:** Implement `depends_on` and `healthcheck` via Ansible wait-loops.
- [ ] **Identity & SSO:** - [ ] Deploy **Authentik**.
    - [ ] Connect Seafile, Komodo, and Sonarr (SSO via OIDC/SAML).
- [ ] **Config Templating:**
    - [ ] Replace hardcoded `.env` files with **Jinja2** templates (`.j2`).
    - [ ] Pull variables from **Ansible Vault**.
- [ ] **Data Mobility:**
    - [ ] Setup **Rclone** (connected to your new MinIO/S3) for offsite backup staging.
    - [ ] Daily `rsync` for heavy volume data to OMV NAS.
## Phase 3: Monitoring, Health & Notifications
- [ ] **Unified Notifications:** Deploy **ntfy.sh** connected to PVE and Ansible.
- [ ] **Host Monitoring:** Deploy **Beszel** for S.M.A.R.T. and RAM alerts.
- [ ] **Log Centralization:** Evaluate a "Light" log aggregator (like **Dozzle** or **Grafana Loki**) if Komodo's native log viewer feels too limited for cross-service debugging.
- [ ] **Uptime Kuma:** Monitor internal services; alert via ntfy.
- [ ] **Landing Page:** Set up **Homepage** as the "Crowning Jewel" for easy access.

## Phase 4: Proxmox & PBS "Absolute Zero" Recovery
- [ ] **Host Backup:** Ansible backup of critical PVE/PBS `/etc/` configs to NAS.
- [ ] **Terraform Blueprints:** Finalize code to recreate VM "shells" on fresh hardware.
- [ ] **Disaster Recovery Runbook:** Document exact steps in MkDocs for a "total melt" recovery.

## Phase 5: Media Production & Simracing
- [ ] **Post-Race Sync:** Ansible-automated `rsync` of VR recordings from CachyOS to OMV.
- [ ] **Resolve NAS Tuning:** Optimize NFS/SMB for 4K Linux editing performance.

## Phase 6: Windows Automation & Portability
- [ ] **VR Gold-State Capture:** Export manual Registry/GPO tweaks for VR/Performance.
- [ ] **PowerShell Master Script:** Create "VR Master" and "Generic Friend" (Winget) scripts.
- [ ] **Smart Ventoy Drive:** Configure `ventoy.json` and Auto-Installation plugin.