# Project Homelab: Infrastructure & Automation Roadmap

## Phase 1: GitOps Foundation & Workspace Optimization

_(See CHANGELOG for completed Phase 1 tasks)_

## Phase 2: Service Migration, Maintenance & Monitoring

### Immediate — Service Migration & Cleanup

- [ ] **Ansible Service Migration:**
  - [x] Migrate **Pi-hole** to Ansible role with Jinja2 compose template and version pin in `services.yml`.
  - [x] Migrate **Arr Stack** (Sonarr, Radarr, Prowlarr, Sabnzbd, Decypharr) to Ansible roles.
  - [x] Migrate **Jellyfin** and **Jellyseerr** to Ansible roles.
  - [x] Deploy new **Paperless-ngx** instance via Ansible role.
  - [x] Migrate **Forgejo** to Ansible roles.
  - [x] Purge legacy manual Docker Compose stacks from `debian-docker` after migration.
  - [ ] Connect all remaining services to **Authentik SSO** (Forgejo, Jellyfin, etc.).
- [ ] **Game Server Stack:**
  - [ ] Evaluate and deploy **Pterodactyl/Pelican** for centralized game server management with web panel.
  - [ ] Dockerize **Terraria** dedicated server (custom Dockerfile - standalone binary, volume-mounted world saves).
  - [ ] Deploy **modded Minecraft** server via Pterodactyl or custom Ansible role.
  - [ ] Configure Caddy/DNS routing for game server access over ZeroTier.
- [ ] **Host Debloating & Maintenance:**
  - [ ] Create debloating Bash script for CachyOS workstation.
  - [ ] Audit all hosts for manually installed packages not in Ansible baseline (`apt-mark showmanual`).
  - [ ] Configure **unattended-upgrades** for weekly automatic security patches across all nodes.
  - [ ] Create Ansible playbook for monthly full update cycle with notification, approval, and PBS snapshot before applying.
  - [ ] Automate Docker cleanup (`docker system prune`) on `debian-docker` via scheduled task.
  - [ ] Validate `common` role hardening hasn't drifted on long-running hosts.
- [ ] **Jinja2 Transition:** Replace any remaining hardcoded `.env` files with `.j2` templates across all Docker services.

### Monitoring, Observability & Dashboards

- [ ] **Prometheus & Grafana on K3s:**
  - [ ] Deploy Prometheus via K8s manifests (or Helm chart as a learning exercise).
  - [ ] Deploy Grafana with persistent storage on NAS.
  - [ ] Deploy `node_exporter` via Ansible to all Linux nodes for host-level metrics.
  - [ ] Create dashboards: host health (CPU, RAM, disk), Docker container status, ZFS pool metrics, ZeroTier network throughput.
- [ ] **Alerting:** Deploy **ntfy.sh** and configure Grafana alert rules to push notifications for disk warnings, service downtime, and high resource usage.
- [ ] **Log Centralization:** Deploy **Loki** on K3s, configure Promtail on all hosts to ship logs. Correlated logging across Caddy → ZeroTier → Docker → application.
- [ ] **Uptime Kuma:** Monitor external service availability; alert via ntfy.

### Ansible & Templating Completion

- [x] **Vault Setup:** Initialize vault for sensitive service credentials.
- [x] **Caddy Deployment:** Deployed Caddy with Cloudflare DNS-01 challenge for wildcard certificates.
- [x] Convert Docker Compose stacks to Ansible `community.docker` modules.
- [x] Remove redundant Komodo from the stack.
- [x] Add `staging` branch/logic to repository and deploy a dedicated `staging` runner.
- [x] Forgejo Actions (CI/CD): Pipeline that lints YAML and Ansible on push to `staging`.
- [ ] **Reverse Proxy Automation:** Script for automated Caddy routing when new services are added.
- [ ] **Logic & Orchestration:** Implement `depends_on` and `healthcheck` via Ansible wait-loops where applicable.

### CI/CD Pipeline Expansion

- [x] Create a `shellcheck` CI/CD pipeline in Forgejo Actions.
- [ ] Integrate **Trivy** (compromised, moved to backlog) into Forgejo Actions to scan Docker images for CVEs before deployment.
- [x] Implement **Gitleaks** or **TruffleHog** to block commits containing exposed secrets.
- [ ] Infracost / Policy Check: Estimate cloud costs or check for open security groups before Terraform applies.

### Terraform — Completed & Ongoing

- [x] Initialize Terraform on `ansible-main`.
- [x] Created reusable `modules/proxmox-vm` for VM provisioning via cloud-init templates.
- [x] Created reusable `modules/proxmox-lxc` for LXC container provisioning.
- [x] Built Debian 13 cloud-init VM template (ID 9000) on Proxmox.
- [x] Upgraded `bpg/proxmox` provider to `0.98` with API token authentication.
- [ ] Move remaining PVE hosts to Terraform (ansible-main migration blocked by state drift — documented as known tech debt).
- [ ] Refactor Terraform modules for reuse across cloud providers (prepare for AWS/Azure).

### Kubernetes — Completed & Ongoing

- [x] Provisioned K3s node (`k3s-01`, VM 201) via Terraform module.
- [x] Deployed **Garage** (S3-compatible object storage) with hand-written manifests.
- [ ] **Helm:** Convert Garage manifests to a Helm chart as a learning exercise.
- [ ] **GitOps:** Evaluate ArgoCD or FluxCD for automatic manifest sync from Git.
- [ ] Migrate stateless services to K3s when monitoring stack proves the cluster is stable.

### Container Lifecycle & Version Management

- [ ] Deploy **Renovate** on Forgejo to scan `services.yml` for version pins and auto-generate PRs.
- [ ] Implement SemVer pinning for all Ansible Docker roles.
- [ ] Automated deployment pipeline: Renovate PR → lint → merge → Ansible redeploy of affected service.

### Custom Docker Images

- [x] **FoundryVTT:** Custom Dockerfile (Node.js 22-slim, version-pinned build, healthcheck, NAS-mounted data).
- [ ] **Terraria:** Custom Dockerfile (standalone binary, 32-bit dependencies, volume-mounted world saves).
- [ ] **Python Health API:** Custom Dockerfile (FastAPI, Docker socket integration, K8s deployment target).

### Deployed Services (Ansible-Managed)

- [x] **Firefly III:** Deployed with Authentik SSO via Caddy `forward_auth`.
- [x] **FoundryVTT:** Custom-built Docker image with NAS-mounted user data.
- [x] **Authentik:** Centralized Identity Provider for SSO.
- [x] **Seafile:** Cloud storage with OIDC SSO on IONOS VPS.
- [x] **Homepage:** Central dashboard.

### Identity & SSO

- [x] Deploy **Authentik**.
- [x] Connect Firefly III to Authentik SSO.
- [x] Connect Seafile to Authentik SSO via OIDC.
- [ ] Connect remaining services (Forgejo, Jellyfin, etc.) to SSO.
- [ ] Create e-mail forwarding and a way for users to register their accounts in Authentik. Manually approved per-service later.

### Data & Storage

- [ ] **Seafile S3 Backend:** Connect Seafile to Garage S3 endpoint for NAS overflow storage.
- [ ] **Hybrid Backup:** Configure VPS Seafile to mirror data to local OMV NAS.
- [ ] Setup **Rclone** for offsite backup staging.
- [ ] Daily `rsync` for heavy volume data to OMV NAS.

### GitHub & Documentation — Completed

- [x] Mirror the homelab repository on GitHub.
- [x] Deploy GitHub Pages for MkDocs documentation.
- [x] Set up GitHub runner to update docs on push.

## Phase 3: Cloud Expansion & Advanced IaC

### AWS (Learning via Homelab)

- [ ] Set up AWS Free Tier account.
- [ ] Terraform an EC2 instance with VPC, subnet, and security group using `hashicorp/aws` provider.
- [ ] Connect AWS instance to ZeroTier mesh for hybrid cloud networking.
- [ ] Deploy a service via Ansible on the AWS instance.
- [ ] Practice Terraform remote state backend on S3 with DynamoDB locking.

### Azure

- [ ] Set up Azure Free Tier account and Resource Group.
- [ ] Terraform an Azure VM with VNet, subnet, and NSG.
- [ ] Migrate Terraform state to Azure Blob Storage Container.
- [ ] Connect Azure VM to ZeroTier mesh.

### Secrets Management Evolution

- [ ] Evaluate **HashiCorp Vault** or **Mozilla SOPS** for dynamic secret injection.
- [ ] Practice secret rotation workflows.

### Continuous Testing (IaC)

- [ ] Implement **Checkov** or **Tfsec** to scan Terraform for security misconfigurations.
- [ ] Evaluate **Molecule** to test Ansible roles in ephemeral Docker containers.

## Phase 4: Proxmox & PBS "Absolute Zero" Recovery

- [ ] **Host Backup:** Ansible backup of critical PVE/PBS `/etc/` configs to NAS.
- [ ] Automate Proxmox Backup Server (PBS) verification.
- [ ] Implement off-site backups for critical application volumes (Seafile data, Authentik DB).
- [ ] **Terraform Blueprints:** Finalize code to recreate VM "shells" on fresh hardware.
- [ ] **Disaster Recovery Runbook:** Document exact steps in MkDocs for a "total melt" recovery.
- [ ] **Architecture Diagram:** Create a comprehensive Mermaid diagram showing full request flow, SPOFs, and component dependencies.

## Phase 5: Media Production & Simracing

- [ ] **Post-Race Sync:** Ansible-automated `rsync` of VR recordings from CachyOS to OMV.
- [ ] **Resolve NAS Tuning:** Optimize NFS/SMB for 4K Linux editing performance.

## Phase 6: Documentation & Portfolio Polish

- [ ] **Onboarding Documentation:**
  - [ ] Comprehensive infrastructure description for new contributors.
  - [ ] Git methodology and branching strategy guide.
  - [ ] Updated network topology with Mermaid diagrams.
  - [ ] Step-by-step onboarding process.
- [ ] **Runbooks:** Proactive troubleshooting decision trees for each critical service.
- [ ] **Capacity Planning:** Documented resource usage trends and growth projections.
- [ ] **Documentation Generator Migration (Zensical):**
  - [ ] Evaluate Zensical once stable.
  - [ ] Migrate MkDocs configuration if warranted.

## Backlog — Future Projects (No Timeline)

### Enterprise Windows Server & Azure Hybrid Cloud

- [ ] Terraform-provisioned Windows Server 2022/2025 VM on Proxmox.
- [ ] Active Directory Domain Services (`corp.potterman.party`).
- [ ] Azure AD Connect for hybrid identity sync.
- [ ] PowerShell endpoint bootstrapping scripts.
- [ ] Microsoft 365 automation via Graph API.

### Network Segmentation & Advanced Networking

- [ ] OPNsense deployment for VLAN segmentation.
- [ ] Separate trust zones for DNS, media, and application workloads.
- [ ] K8s NetworkPolicies for pod-level isolation.

### High Availability Experimentation

- [ ] Second `debian-docker` VM for Docker-level HA with Caddy load balancing.
- [ ] Second K3s node for Kubernetes-native HA and scheduling practice.
- [ ] Database replication patterns (PostgreSQL, MariaDB).

### Enterprise Identity Federation

- [ ] Federate Authentik with Microsoft Entra ID via SAML/OIDC.
