# 🚀 Project Homelab: Infrastructure & Automation Roadmap

## Phase 1: GitOps Foundation & Workspace Optimization
*(See CHANGELOG for completed Phase 1 tasks)*

## Phase 2: Ansible Migration, SSO & Logic

- [x] **Ansible Hub (.105) Hardening:**
    - [x] Security/Critical: Check Forgejo history and "nuke" the sensitive commits from Phase 1 audit.
    - [x] Configure `git-sync` or a simple `post-receive` hook to keep CachyOS and Hub in sync via Forgejo.
    - [x] **Inventory Refactor:** Move to directory structure with `production` and `staging` files.
    - [x] Centralize variables: Move to `ansible/group_vars/vars.yml`.
    - [x] Set Vault "human-readable" variables (referencing encrypted strings via clear names).
- [ ] **Workstation Standardization (Ansible):**
    - [x] Unify all environments (Debian-Docker, PVE, etc.) to match the CachyOS setup.
    - [x] Deploy `fish` shell and autocomplete globally.
    - [x] Configure passwordless `sudo` in `/etc/sudoers.d/` for the `potterman` user.
    - [x] Deploy `fish` shell, starship prompt, and autocomplete globally.
    - [ ] Trimming down unused/unneeded default applications across hosts.
    - [x] **OS Hardening:** Disable root SSH login and enforce SSH-key only authentication across all nodes.
- [ ] **Ansible Migration & Templating:**
    - [x] **Vault Setup:** Initialize vault for sensitive service credentials.
    - [x] **Caddy Deployment:** Deployed Caddy with Cloudflare DNS-01 challenge for wildcard certificates.
    - [ ] **Jinja2 Transition:** Replace hardcoded `.env` files with `.j2` templates for all Docker services.
    - [ ] **Reverse Proxy Automation:** Add script for automated routing.
    - [x] Convert Docker Compose stacks to Ansible `community.docker` modules.
    - [ ] **Logic & Orchestration:** Implement `depends_on` and `healthcheck` via Ansible wait-loops.
    - [x] Remove redundant Komodo from the stack.
    - [x] Add `staging` branch/logic to repository and deploy a dedicated `staging` runner.
    - [x] Forgejo Actions (CI/CD): Create a pipeline that triggers on git push to lint YAML files and run a "check mode" (dry-run) of playbooks.
    - [ ] Create a `shellcheck` CI/CD pipeline to Forgejo Actions.
    - [ ] Infracost / Policy Check: Add a step in the CI/CD to estimate cloud costs or check for open security groups before Terraform applies.
    - [ ] Integrate **Trivy** into Forgejo Actions to automatically scan Docker images for CVEs (vulnerabilities) before deployment.
    - [ ] Implement **Gitleaks** or **TruffleHog** in the CI/CD pipeline to block commits that contain exposed API keys or passwords.
- [ ] **Terraform Init and Refactor (The Builder)**
  - [x] Initialize Terraform on the `ansible-hub` Deployment server.
  - [ ] Refactor Terraform code into reusable modules.
    - [ ] Move all existing PVE hosts to Terraform
      - [ ] Standardize Cloud-Init deployments (Injecting base `potterman` user and SSH key on boot).
      - [ ] Standardize Hardware profiles (CPU, RAM, Disk sizing).
- [x] **Github clone & MkDocs migration**
  - [x] Mirror the homelab repository on Github
  - [x] Deploy GitHub Pages for the MkDocs documentation
  - [x] Set up GitHub runner to update the docs after any pulls
- [ ] **Azure State & Secret Backend:**
    - [ ] **Cloud Onboarding:** Set up an Azure Free Tier account and Resource Group.
    - [ ] **Remote State Backend:** Migrate Terraform state to an **Azure Blob Storage Container** (using Azure Storage Account native state locking). 
    - [ ] **Local MinIO Deployment:** Deploy a local S3-compatible MinIO instance on the Docker VM via Ansible/Jinja2 (for local high-speed storage).
    - [ ] **Hybrid Cloud Sync:** Configure a task to sync local MinIO buckets to Azure Blob Storage for disaster recovery, practicing hybrid-cloud data mobility.
    - [ ] Deploy **HashiCorp Vault** or integrate **Mozilla SOPS** (using Azure Key Vault / AWS KMS for the master key).
    - [ ] Refactor Ansible pipelines to fetch secrets dynamically at runtime rather than storing them in Ansible Vault.
- [ ] **Infrastructure Expansion & VPS Migration:**
    - [x] **Cloud Extension (Ansible):** Provisioned IONOS VPS, automated Docker & DNS, and deployed TeamSpeak over ZeroTier.
    - [x] **Cloud Architecture:** Finalize and deploy "Split-Proxy" architecture for future IONOS VPS.    
    - [x] **Teamspeak 6:** Deploy public-facing TS6 server on the VPS.
    - [x] **Seafile Migration:** Move Seafile instance from local homelab to the public VPS.
    - [ ] **Hybrid Backup:** Configure VPS Seafile to mirror/backup data directly to the local OMV NAS.
    - [ ] **Storage Contingency:** Plan and document Cloudflare R2 integration for Seafile in case VPS local storage hits maximum capacity.
    - [ ] **Azure Cloud Extension:** Use Terraform to provision an Azure B1s (Free Tier) Virtual Machine.
    - [ ] **Hybrid Networking:** Connect the Azure VM to your local Proxmox environment via the ZeroTier SDN mesh.
- [ ] **Continuous Testing (IaC):**
    - [ ] Implement **Checkov** or **Tfsec** in CI/CD to scan Terraform for security misconfigurations (e.g., exposed ports, unencrypted disks) before `terraform apply`.
    - [ ] Evaluate **Molecule** to test Ansible roles in ephemeral Docker containers to ensure idempotency before merging to `main`.
- [ ] **Cloud-Native Container Orchestration (Kubernetes):**
    - [ ] Provision a highly available K3s/RKE2 cluster using Terraform and Ansible.
    - [ ] Migrate stateless applications (e.g., Homepage, Pi-hole) from Ansible Docker modules to **Helm Charts** or **Kustomize**.
    - [ ] Deploy **ArgoCD** or **FluxCD** to continuously monitor the Git repository and automatically pull/sync K8s deployments (True GitOps).
- [ ] **Identity & SSO + Entra ID Integration:**
    - [x] Deploy **Authentik**.
    - [ ] Connect existing services (Forgejo, Seafile, etc.) to SSO.
    - [ ] **Enterprise Identity:** Federate local Authentik with **Microsoft Entra ID (Azure AD)** via SAML/OIDC, allowing login to your homelab using Microsoft credentials.
- [ ] **Data Mobility:**
    - [ ] Setup **Rclone** for offsite backup staging.
    - [ ] Daily `rsync` for heavy volume data to OMV NAS.
- [ ] **Cloud Migration Simulation**
  - [ ] Document the process of moving Terraform State from local disk to AWS S3
- [ ] **Container Lifecycle Management:**
    - [ ] Implement explicit Semantic Versioning (SemVer) pinning for all Ansible Docker roles.
    - [ ] Deploy and configure **Renovate** to automate PR generation for container and IaC updates.

## Phase 3: Monitoring, Health & Notifications

- [ ] **Unified Notifications:** Deploy **ntfy.sh** connected to PVE and Ansible.
- [ ] **Enterprise Observability Stack (Prometheus & Grafana):** - [ ] Deploy Prometheus to scrape metrics, and Grafana to visualize them.
    - [ ] Deploy `node_exporter` via Ansible to all Linux nodes, and `windows_exporter` to the Windows Server, creating a unified dashboard.
- [ ] **Log Centralization:** Evaluate a "Light" log aggregator (Loki).
- [ ] **Uptime Kuma:** Monitor internal services; alert via ntfy.
- [ ] Custom Tooling (Python/PowerShell): Write a script that uses the Proxmox and **Azure REST API** to generate a summary report of the infrastructure health and billing costs.
- [ ] **Landing Page:** Set up **Homepage** as the "Crowning Jewel" for easy access.
- [ ] Documentation as Code: MkDocs
- [ ] **Onboarding Documentation** 
  - [ ] Create a thorough description of the Infrastructure
  - [ ] Git methology and principles
  - [ ] Updated network topology
  - [ ] A guide for new "onboarding" process.
- [ ] **Documentation Generator Migration (Zensical)**
  - [ ] Evaluate Zensical once it reaches a stable release.
  - [ ] Migrate `mkdocs.yml` configuration and extensions to the new Zensical format.
  - [ ] Update `.github/workflows/deploy-docs.yml` to use the Zensical build commands instead of MkDocs.

## Phase 4: Proxmox & PBS "Absolute Zero" Recovery

- [ ] **Host Backup:** Ansible backup of critical PVE/PBS `/etc/` configs to NAS.
- [ ] Automate Proxmox Backup Server (PBS) verification.
- [ ] Implement off-site backups for critical application volumes (Seafile data, Authentik DB).
- [ ] **Terraform Blueprints:** Finalize code to recreate VM "shells" on fresh hardware.
- [ ] **Disaster Recovery Runbook:** Document exact steps in MkDocs for a "total melt" recovery.
- [ ] **Enterprise Backup Simulation (Veeam):**
    - [ ] Deploy Veeam Backup & Replication (Community Edition) on the Windows Server VM.
    - [ ] Configure Veeam Agent backups for a Windows endpoint to a local NAS SMB share, simulating corporate workstation disaster recovery.

## Phase 5: Media Production & Simracing

- [ ] **Post-Race Sync:** Ansible-automated `rsync` of VR recordings from CachyOS to OMV.
- [ ] **Resolve NAS Tuning:** Optimize NFS/SMB for 4K Linux editing performance.

## Phase 6: Enterprise Windows Server & Azure Hybrid Cloud

- [ ] **Windows Server Infrastructure (IaC):**
    - [ ] Use Terraform to provision a **Windows Server 2022/2025** VM on Proxmox.
    - [ ] Configure Ansible to manage Windows nodes via `winrm` or OpenSSH for Windows.
- [ ] **Active Directory Domain Services (AD DS):**
    - [ ] Write a PowerShell script/Ansible playbook to promote the Windows Server to a Domain Controller (e.g., `corp.potterman.party`). 
    - [ ] Implement foundational Group Policy Objects (GPOs) for security baselines.
- [ ] **Azure AD Connect (Hybrid Identity):**
    - [ ] Install Azure AD Connect on the Windows Server to sync local Active Directory users up to your Azure Entra ID tenant.
- [ ] **Client Endpoint Management (PowerShell):**
    - [ ] **VR/Sim Gold-State:** Export manual Registry/GPO tweaks for high-performance VR runtimes.
    - [ ] **PowerShell Master Script:** Create endpoint bootstrapping scripts using `Winget` to automate client software deployment.
    - [ ] **Smart Ventoy Drive:** Configure `ventoy.json` and Windows OS Auto-Installation (Unattended XML) for bare-metal client provisioning.
- [ ] **Microsoft 365 Automation (Graph API):**
    - [ ] Provision a free M365 Developer Tenant.
    - [ ] Write a PowerShell script using the `MgGraph` module to automate user onboarding (creating an Entra ID user, assigning an E5 license, and adding them to a Teams group).