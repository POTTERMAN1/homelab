# Project Homelab: Infrastructure & Automation Roadmap

## Phase 1: GitOps Foundation & Workspace Optimization

_(See CHANGELOG for completed Phase 1 tasks)_

## Phase 2: Service Migration, Maintenance & Monitoring

### DNS Migration & Proxy Automation

- [x] **DNS Migration — Cloudflare → Desec DNS:**
  - [x] Export Cloudflare DNS zone as BIND file.
  - [x] Lower Cloudflare TTLs to 60s and wait one TTL cycle before cutover.
  - [x] Create Desec DNS account, import zone.
  - [x] Vault Desec API token (`vault_desec_dns_token`).
  - [x] Swap Caddy binary download URL to use `caddy-dns/hetzner` plugin.
  - [x] Update `Caddyfile.j2` TLS snippet from `cloudflare` → `hetzner`.
  - [x] Update Ansible caddy role env file and vault references.
  - [x] Update NS records on Namecheap → Desec nameservers.
  - [x] Run Ansible caddy role, confirm TLS renews cleanly on Desec DNS-01.
- [ ] **Caddyfile Automation:**
  - [ ] Redesign `services.yml` schema — add `host:` and `proxy_type:` fields to all entries.
  - [x] Fix existing `services.yml` consistency issues: `subdmain` typos (authentik, homepage), missing `internal_port` fields (pihole, paperless).
  - [ ] Define five proxy patterns: `standard`, `forward_auth`, `tls_skip`, `external`, `nodeport`.
  - [ ] Rewrite `Caddyfile.j2` as a Jinja2 loop over `app_services` dict, rendering blocks by `proxy_type`.
  - [ ] Verify all existing site blocks are generated correctly before removing manual entries.

### Service Migration & Cleanup

- [ ] **Ansible Service Migration:**
  - [x] Migrate **Pi-hole** to Ansible role with Jinja2 compose template and version pin in `services.yml`.
  - [x] Migrate **Arr Stack** (Sonarr, Radarr, Prowlarr, Sabnzbd, Decypharr) to Ansible roles.
  - [x] Migrate **Jellyfin** and **Jellyseerr** to Ansible roles.
  - [x] Deploy new **Paperless-ngx** instance via Ansible role.
  - [x] Migrate **Forgejo** to Ansible roles.
  - [x] Purge legacy manual Docker Compose stacks from `debian-docker` after migration.
  - [ ] Connect all remaining services to **Authentik SSO** (Forgejo, Jellyfin, etc.).
- [ ] **Game Server Stack:**
  - [ ] Evaluate and deploy **Pterodactyl/Pelican** for centralized game server management.
  - [ ] Dockerize **Terraria** dedicated server (custom Dockerfile, volume-mounted world saves).
  - [ ] Deploy **modded Minecraft** server via Pterodactyl or custom Ansible role.
  - [ ] Configure Caddy/DNS routing for game server access over ZeroTier.
- [ ] **Host Debloating & Maintenance:**
  - [ ] Create debloating Bash script for CachyOS workstation.
  - [ ] Audit all hosts for manually installed packages not in Ansible baseline (`apt-mark showmanual`).
  - [ ] Configure **unattended-upgrades** for weekly automatic security patches across all nodes.
  - [ ] Create Ansible playbook for monthly full update cycle with notification, approval, and PBS snapshot before applying.
  - [ ] Automate Docker cleanup (`docker system prune`) on `debian-docker` via scheduled task.
  - [ ] Validate `common` role hardening hasn't drifted on long-running hosts.
  - [ ] Create Ansible `maintenance` role — wraps Docker prune, journal vacuum, apt autoremove into a tagged playbook for on-demand runs.
- [ ] **Jinja2 Transition:** Replace any remaining hardcoded `.env` files with `.j2` templates across all Docker services.
- [ ] **Homepage Expansion:**
  - [ ] Flesh out `homepage_services.yaml.j2` to cover full stack, driven from `app_services` dict.
  - [ ] Define service groups: Infrastructure, Identity, Media, Services, Management.

### Monitoring, Observability & Alerting

- [ ] **Storage Prerequisites (K3s):**
  - [ ] Confirm local-path-provisioner is active (from K3s audit).
  - [ ] Deploy NFS StorageClass via `nfs-subdir-external-provisioner` for Loki persistent storage on NAS.
  - [ ] Use local-path for Prometheus (performance), NFS for Loki (retention).
- [ ] **K3s Ansible Role:**
  - [ ] Create `k3s` Ansible role — install, kubeconfig, Helm installation, version pin.
  - [ ] Migrate current manually-provisioned K3s node to Ansible management.
  - [ ] Add to `site.yml` K3s play.
- [ ] **ntfy — Redundant Alerting:**
  - [ ] Deploy ntfy on `debian-docker` (Docker Compose, Ansible role).
  - [ ] Deploy ntfy on `ionos_vps` (independent instance, survives local outage).
  - [ ] Subscribe phone app to both instances on same topic — redundant delivery.
  - [ ] Expose both via Caddy (`ntfy.potterman.party`).
- [ ] **Prometheus & Grafana on K3s (kube-prometheus-stack):**
  - [ ] Deploy kube-prometheus-stack via Helm (Prometheus Operator, Grafana, Alertmanager, node_exporter DaemonSet).
  - [ ] Configure Grafana with native Authentik OIDC.
  - [ ] Set Prometheus retention to 30 days.
  - [ ] Configure external scrape targets for `debian-docker`, `ionos_vps`, `pve`.
  - [ ] Pre-built K3s cluster health dashboards from community (import first, build custom later).
- [ ] **Observability Agent Role (all non-K3s hosts):**
  - [ ] Create `observability-agent` Ansible role — node_exporter, cAdvisor, Alloy.
  - [ ] Deploy to `debian-docker`, `ionos_vps`, `pve` (exclude `ansible_master`, `workstations`).
  - [ ] Configure Alloy with River config (`alloy-config.river.j2`) to ship logs to Loki.
  - [ ] node_exporter on port 9100, cAdvisor on port 8080.
- [ ] **Loki on K3s:**
  - [ ] Deploy Loki with NFS-backed PVC for 90-day log retention.
  - [ ] Correlated logging: Caddy → ZeroTier → Docker → application.
- [ ] **Alertmanager:**
  - [ ] Configure Alertmanager webhook receiver → ntfy (both instances).
  - [ ] Configure email receiver → Stalwart (deferred until Stalwart deployed).
  - [ ] Alert rules: disk warnings, service downtime, high resource usage, ZFS pool health.
- [ ] **Blackbox Exporter:**
  - [ ] Deploy Blackbox Exporter for HTTP endpoint probing.
  - [ ] Replaces Uptime Kuma — native Prometheus integration, feeds Alertmanager directly.
  - [ ] ~~Uptime Kuma~~ — removed from roadmap, superseded by Blackbox Exporter.
- [ ] **Grafana Dashboards:**
  - [ ] Host health: CPU, RAM, disk per node.
  - [ ] Docker container status and resource usage.
  - [ ] ZFS pool metrics.
  - [ ] ZeroTier network throughput.
  - [ ] K3s cluster health.
  - [ ] Service endpoint availability (Blackbox Exporter).

### Email — Self-Hosted

- [ ] **Stalwart Mail on IONOS VPS:**
  - [ ] IONOS VPS IP confirmed clean on all major blocklists.
  - [ ] Deploy Stalwart Mail via Ansible role (single binary, SMTP/IMAP/JMAP).
  - [ ] Configure SPF, DKIM, DMARC records on Hetzner DNS.
  - [ ] Set PTR record for VPS IP via IONOS panel.
  - [ ] Replace Cloudflare Email Routing with Stalwart catch-all.
  - [ ] Wire Alertmanager email receiver to Stalwart SMTP.

### LLM Stack (CachyOS Workstation)

- [ ] **Ansible-managed LLM stack (CachyOS):**
  - [ ] llama-server native install — system service, version-pinned binary, checksum verified.
  - [ ] Open WebUI native venv install at `/opt/open-webui`, data at `~/.local/share/open-webui`.
  - [ ] Models: `gemma4:e4b` (general), `qwen2.5-coder:14b` (IaC/code), `nomic-embed-text` (embeddings).
  - [ ] llm-sync role: rsync from `ansible-main` → `~/llm-knowledge/`, systemd oneshot, dedicated SSH keypair.
  - [ ] llm-backup role: rsync to NAS, systemd oneshot.
  - [ ] Zellij layout for stack control (ollama, open-webui, sync logs, GPU watch).
- [ ] **SearXNG migration:** Move SearXNG from CachyOS local Docker to `debian-docker` as always-on service, expose via Caddy at `search.potterman.party`.
- [ ] **Dockerize Ollama stack (future consideration):** Evaluate after native install is stable — not current priority.

### Ansible & CI/CD

- [x] **Vault Setup:** Initialize vault for sensitive service credentials.
- [x] **Caddy Deployment:** Deployed Caddy with DNS-01 challenge for wildcard certificates.
- [x] Convert Docker Compose stacks to Ansible `community.docker` modules.
- [x] Remove redundant Komodo from the stack.
- [x] Add `staging` branch/logic and dedicated staging runner.
- [x] Forgejo Actions CI/CD: lint pipeline on push to `staging`.
- [x] Shellcheck in CI pipeline.
- [x] Gitleaks in CI pipeline.
- [ ] **GitLab CE deployment on `debian-docker`:**
  - [ ] Deploy `gitlab/gitlab-ce` omnibus container via Ansible role, Compose-managed.
  - [ ] Pin version in `services.yml`, expose via Caddy at `gitlab.potterman.party`.
  - [ ] Template `gitlab.rb` via Jinja2 — external URL, reverse proxy NGINX config, vaulted secrets.
  - [ ] Deploy GitLab Runner as separate container, Docker executor, socket-mounted.
  - [ ] Register runner to CE instance via vaulted registration token.
  - [ ] Configure per-repo push mirrors from Forgejo → GitLab CE.
  - [ ] Wire GitLab CE to Authentik SSO via OIDC.
- [ ] Integrate **Trivy** into CI pipeline — blocked, supply chain compromise in 0.69.4–0.69.6, re-evaluate before adding.
- [ ] Infracost / Policy Check: Cost estimation and security group validation before Terraform applies.
- [ ] **Logic & Orchestration:** `depends_on` and `healthcheck` via Ansible wait-loops where applicable.

### GitLab CI/CD Parity (gitlab.com)

- [ ] Mirror selected homelab repos from GitLab CE → gitlab.com for external visibility.
- [ ] Write `.gitlab-ci.yml` equivalents of existing Forgejo lint pipeline — yamllint, ansible-lint, shellcheck, gitleaks.
- [ ] Register self-hosted runner on gitlab.com project to avoid shared runner minute limits.
- [ ] Practice GitLab-specific CI/CD features: environments, protected branches, merge request approvals, deployment jobs.
- [ ] Document differences between Forgejo Actions and GitLab CI/CD syntax in MkDocs — this is portfolio-relevant.

### Container Lifecycle & Version Management

- [ ] Deploy **Renovate** on Forgejo to scan `services.yml` for version pins and auto-generate PRs.
- [ ] Implement SemVer pinning for all Ansible Docker roles.
- [ ] Automated deployment pipeline: Renovate PR → lint → merge → Ansible redeploy of affected service.
- [ ] Refactor Authentik role: move hardcoded PostgreSQL and Redis versions from `authentik_compose.yaml.j2` to `services.yml` for Renovate compatibility.
- [ ] **`potter-ci-lint` image maintenance:**
  - [ ] Re-evaluate Trivy inclusion once supply chain compromise is resolved.
  - [ ] Pin all tool versions in the Dockerfile — no `latest` tags, no unversioned pip installs.
  - [ ] Publish image to GitLab CE container registry as secondary registry alongside Forgejo.

### Terraform

- [x] Initialize Terraform on `ansible-main`.
- [x] Created reusable `modules/proxmox-vm` and `modules/proxmox-lxc`.
- [x] Built Debian 13 cloud-init VM template on Proxmox.
- [x] Upgraded `bpg/proxmox` provider to `0.98`.
- [ ] Move remaining PVE hosts to Terraform (ansible-main migration blocked by state drift — documented tech debt).
- [ ] Refactor Terraform modules for reuse across cloud providers.

### Kubernetes

- [x] Provisioned K3s node via Terraform module.
- [x] Deployed **Garage** (S3-compatible object storage) with hand-written manifests.
- [ ] **Helm:** Convert Garage manifests to Helm chart as a learning exercise.
- [ ] **GitOps:** Evaluate ArgoCD or FluxCD for automatic manifest sync from Git.
- [ ] Migrate stateless services to K3s when observability stack proves cluster stability.

### Data & Storage

- [ ] **Seafile S3 Backend:** Connect Seafile to Garage S3 endpoint for NAS overflow storage.
- [ ] **Hybrid Backup:** Configure VPS Seafile to mirror data to local OMV NAS.
- [ ] Setup **Rclone** for offsite backup staging.
- [ ] Daily `rsync` for heavy volume data to OMV NAS.

### Identity & SSO

- [x] Deploy **Authentik**.
- [x] Connect Firefly III to Authentik SSO.
- [x] Connect Seafile to Authentik SSO via OIDC.
- [ ] Connect remaining services (Forgejo, Jellyfin, etc.) to SSO.
- [ ] Create email forwarding and user registration flow in Authentik — manually approved per-service.

### GitHub & Documentation

- [x] Mirror homelab repository on GitHub.
- [x] Deploy GitHub Pages for MkDocs documentation.
- [x] Set up GitHub runner to update docs on push.

## Phase 3: Cloud Expansion & Advanced IaC

### AWS (Learning via Homelab)

- [ ] Set up AWS Free Tier account.
- [ ] Terraform EC2 instance with VPC, subnet, and security group.
- [ ] Connect AWS instance to ZeroTier mesh.
- [ ] Deploy a service via Ansible on the AWS instance.
- [ ] Practice Terraform remote state on S3 with DynamoDB locking.

### Azure

- [ ] Set up Azure Free Tier account and Resource Group.
- [ ] Terraform Azure VM with VNet, subnet, and NSG.
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
- [ ] **Terraform Blueprints:** Finalize code to recreate VM shells on fresh hardware.
- [ ] **Disaster Recovery Runbook:** Document exact steps in MkDocs for a total-melt recovery.
- [ ] **Architecture Diagram:** Comprehensive Mermaid diagram — full request flow, SPOFs, component dependencies.

## Phase 5: Media Production & Simracing

- [ ] **Post-Race Sync:** Ansible-automated `rsync` of VR recordings from CachyOS to OMV.
- [ ] **NAS Tuning:** Optimize NFS/SMB for 4K Linux editing performance.

## Phase 6: Documentation

- [ ] **Onboarding Documentation:** Infrastructure description, Git methodology, network topology, onboarding process.
- [ ] **Runbooks:** Proactive troubleshooting decision trees for each critical service.
- [ ] **Capacity Planning:** Documented resource usage trends and growth projections.
- [ ] **Documentation Generator Migration (Zensical):** Evaluate once stable, migrate if warranted.

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

### Security News Dashboard

- [ ] Evaluate Glance, integrate with Homepage.
- [ ] Focus: package supply chain alerts, CVE feeds, IT security news for homelab, work, and Windows environments.
