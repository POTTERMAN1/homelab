# 🚀 Project "Absolute Zero": Infrastructure & Automation Roadmap

## Phase 1: GitOps Foundation & Workspace Optimization
- [ ] **Fix Renovate 401 Error:** Refresh GitHub PAT (repo/read:packages) and update Forgejo secrets.
- [ ] **Forgejo Branching Strategy:** Implement Protected `main` and `staging` branches.
- [ ] **Zellij Dashboard:** Create `.kdl` layout with tabs for Ansible, PVE, OMV, and Git logs.
- [ ] **VSCodium Refinement:** Install Ansible/Terraform/YAML extensions + Nerd Fonts.
- [ ] **Secrets Management:** Set up **Ansible Vault** for sensitive YAML variables.
- [ ] **Documentation Start:** Initialize **Material for MkDocs**.
    - [ ] Create `docs/architecture.md` with **Mermaid.js** network diagrams.

## Phase 2: Ansible Migration, SSO & Logic
- [ ] **Compose-to-Ansible:** Migrate all stacks to Ansible playbooks.
- [ ] **Boot Order & Dependencies:** Use `depends_on` + `healthcheck` conditions.
- [ ] **Identity & SSO:** Deploy **Authentik**. Integrate with Seafile, Komodo, and Sonarr.
- [ ] **Config Versioning:** Templatize all `.env` and `.conf` files in Git.
- [ ] **Granular Backups:** Daily `rsync` tasks to mirror volume data to OMV NAS.

## Phase 3: Monitoring, Health & Notifications
- [ ] **Unified Notifications:** Deploy **ntfy.sh** connected to PVE and Ansible.
- [ ] **Host Monitoring:** Deploy **Beszel** for S.M.A.R.T. and RAM alerts.
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
