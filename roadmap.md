# 🚀 Project Homelab: Infrastructure & Automation Roadmap

## Phase 1: GitOps Foundation & Workspace Optimization
*(See CHANGELOG for completed Phase 1 tasks)*

## Phase 2: Ansible Migration, SSO & Logic

- [ ] **Ansible Hub (.105) Hardening:**
    - [x] Security/Critical: Check Forgejo history and "nuke" the sensitive commits from Phase 1 audit.
    - [ ] Configure `git-sync` or a simple `post-receive` hook to keep CachyOS and Hub in sync via Forgejo.
    - [x] **Inventory Refactor:** Move to directory structure with `production` and `staging` files.
    - [ ] Centralize variables: Move to `ansible/group_vars/vars.yml`.
    - [x] Set Vault "human-readable" variables (referencing encrypted strings via clear names).
- [ ] **Ansible Migration & Templating:**
    - [x] **Vault Setup:** Initialize vault for sensitive service credentials.
    - [ ] **Jinja2 Transition:** Replace hardcoded `.env` files with `.j2` templates for all Docker services.
    - [ ] **Reverse Proxy Automation:** Add script for automated routing.
    - [ ] Convert Docker Compose stacks to Ansible `community.docker` modules.
    - [ ] **Logic & Orchestration:** Implement `depends_on` and `healthcheck` via Ansible wait-loops.
    - [ ] Remove redundant Komodo from the stack.
    - [ ] Add `staging` branch/logic to repository and deploy a dedicated `staging` runner.
    - [ ] Forgejo Actions (CI/CD): Create a pipeline that triggers on git push to lint YAML files and run a "check mode" (dry-run) of playbooks.
    - [ ] Infracost / Policy Check: Add a step in the CI/CD to estimate cloud costs or check for open security groups before Terraform applies.
- [ ] **Terraform Init and Refactor**
  - [ ] Initialize Terraform on the `ansible-hub` Deployment server.
  - [ ] Refactor Terraform code into reusable modules.
    - [ ] Move all existing PVE hosts to Terraform
      - [ ] Configuration and shell parity with CachyOS
      - [ ] SSH config parity
      - [ ] Unified or host-specific list of applications, trimming down unused, unneded ones.
      - [ ] Hardening, ensuring no root user access, disable password logins in favor of SSH keys
- [ ] **Github clone & MkDocs migration**
  - [ ] Mirror the homelab & docker-compose repositories on Github
  - [ ] Deploy GitHub Pages for the MkDocs documentation
  - [ ] Set up GitHub runner to update the docs after any pulls/
- [ ] **State & Secret Backend:**
    - [ ] **Cloud Onboarding:** Set up an AWS account to utilize their Free Tier Object Storage.
    - [ ] **Remote S3 Backend:** Migrate Terraform state to a Cloud-hosted S3 Bucket with DynamoDB (for state locking).
    - [ ] **Local MinIO Deployment:** Deploy a local S3-compatible MinIO instance on the Docker VM via Ansible/Jinja2 (for local high-speed storage).
    - [ ] **Hybrid Cloud Sync:** Configure a task to sync local MinIO buckets to AWS/OCI for disaster recovery, practicing hybrid-cloud data mobility.
- [ ] **Infrastructure Expansion:**
    - [ ] **Cloud Architecture Defined:** Establish "Split-Proxy" architecture for future IONOS VPS to prevent "Hairpin Routing" bandwidth bottlenecks.
    - [ ] **K3s via Ansible:** Provision a 3-node cluster on Proxmox using Cloud-Init templates.
    - [ ] **Cloud Extension:** Use Terraform for an OCI (Oracle) or AWS "Always Free" instance.
- [ ] **Identity & SSO:**
    - [ ] Deploy **Authentik**.
    - [ ] Connect existing services (Forgejo, MinIO, etc.) to SSO.
- [ ] **Data Mobility:**
    - [ ] Setup **Rclone** for offsite backup staging.
    - [ ] Daily `rsync` for heavy volume data to OMV NAS.
- [ ] **Cloud Migration Simulation**
  - [ ] Document the process of moving Terraform State from local disk to AWS S3

## Phase 3: Monitoring, Health & Notifications

- [ ] **Unified Notifications:** Deploy **ntfy.sh** connected to PVE and Ansible.
- [ ] **Host Monitoring:** Deploy **Grafana** for S.M.A.R.T. and RAM alerts.
- [ ] **Log Centralization:** Evaluate a "Light" log aggregator (Loki).
- [ ] **Uptime Kuma:** Monitor internal services; alert via ntfy.
- [ ] Custom Tooling (Python): Write a small Python script that uses the Hetzner/Proxmox/AWS API to generate a summary report of your infrastructure costs or resource usage.
- [ ] **Landing Page:** Set up **Homepage** as the "Crowning Jewel" for easy access.
- [ ] Documentation as Code: MkDocs
- [ ] **Onboarding Documentation** 
  - [ ] Create a thorough description of the Infrastructure
  - [ ] Git methology and principles
  - [ ] Updated network topology
  - [ ] A guide for new "onboarding" process.

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