# Project Homelab: Infrastructure & Automation Roadmap

---

## Phase 1: GitOps Foundation & Workspace Optimization

*(Completed — see CHANGELOG)*

---

## Phase 2: Service Migration, Maintenance & Monitoring

### DNS & Proxy

- [x] Migrate DNS from Cloudflare → deSEC (EU jurisdiction, non-profit)
- [x] Vault deSEC API token, update Caddy role
- [x] Redesign `services.yml` schema — `host:`, `proxy_type:` fields, five proxy patterns
- [ ] Rewrite `Caddyfile.j2` as Jinja2 loop over `app_services` dict

### Service Migration

- [x] Migrate Pi-hole, Arr stack, Jellyfin, Jellyseerr, Paperless-ngx, Forgejo to Ansible roles
- [x] Purge legacy manual Docker Compose stacks from `debian-docker`
- [x] Jinja2 templates for all Docker service `.env` files
- [ ] Connect remaining services to Authentik SSO (Forgejo, Jellyfin, etc.)
- [ ] Firefly III SSO fix — switch `AUTHENTICATION_GUARD` from `remote_user_guard` → `web`, verify Abacus PAT auth, then migrate to native OIDC
- [ ] FoundryVTT v14 upgrade — audit module/plugin compatibility (Levels module especially), drop new zip into role build context, bump `foundry_version` in `services.yml`
- [ ] Homepage expansion — full stack coverage, service groups driven from `app_services` dict

### Shell Standardisation

- [ ] Replace `fish` with `zsh` on all hosts via Ansible `common` role
- [ ] Replicate CachyOS zsh config — zsh-autosuggestions, zsh-syntax-highlighting, fzf, starship
- [ ] Handle Arch vs Debian plugin paths via `ansible_os_family` conditionals
- [ ] Full keybind set — HOME/END, word navigation, history search

### Host Maintenance

- [ ] Audit all hosts for manually installed packages not in Ansible baseline
- [ ] Configure `unattended-upgrades` for weekly security patches across all nodes
- [ ] Ansible `maintenance` role — Docker prune, journal vacuum, apt autoremove
- [ ] Monthly full update cycle — notification, approval gate, PBS snapshot before applying
- [ ] Validate `common` role hardening hasn't drifted on long-running hosts
- [ ] Add `iperf3` to `common` role baseline package list
- [ ] CachyOS debloating script
- [ ] `cachy-cleanup.sh` — complete `health_report` function (`systemctl --failed`, kernel reboot detection, pending updates, `.pacnew` files, foreign packages via `pacman -Qm`)
- [ ] ASRock B450 Steel Legend BIOS update — flash P10.60 for stability improvements

### Game Servers

- [x] Deploy Pterodactyl/Pelican for centralised game server management
- [x] Dockerise Terraria dedicated server
- [ ] Deploy modded Minecraft server via Pelican

### LLM Stack (CachyOS Workstation)

- [ ] llama-server native install — system service, version-pinned binary, checksum verified
- [ ] Open WebUI native venv at `/opt/open-webui`
- [ ] Models: `gemma4:e4b` (general), `qwen2.5-coder:14b` (IaC/code), `nomic-embed-text` (embeddings)
- [ ] llm-sync role — rsync from `ansible-main`, systemd oneshot, dedicated SSH keypair
- [ ] llm-backup role — rsync to NAS, systemd oneshot
- [ ] Migrate SearXNG from CachyOS local Docker → `debian-docker`, expose at `search.potterman.party`

---

## Phase 3: Observability, Security & GitOps

### Monitoring Stack (K3s)

- [x] Pre-flight: verify NFS mount on `k3s-node1`, confirm OMV export path
- [ ] K3s Ansible role — install, kubeconfig, Helm, version pin, add to `site.yml`
- [ ] Deploy NFS StorageClass via `nfs-subdir-external-provisioner` for Loki
- [ ] kube-prometheus-stack — Prometheus Operator, Grafana, Alertmanager, node_exporter DaemonSet
- [ ] Grafana with Authentik native OIDC
- [ ] Loki — NFS-backed PVC, 90-day retention
- [ ] OpenTelemetry + Grafana Tempo — distributed tracing, completes observability triad
- [ ] Blackbox Exporter — HTTP endpoint probing, replaces Uptime Kuma
- [ ] Alertmanager — webhook → ntfy, email → Stalwart (deferred), alert rules for disk/service/ZFS/ZeroTier
- [ ] DORA metrics dashboard in Grafana
- [ ] SLOs/error budgets per service — tracked in Grafana

### Observability Agents (All Non-K3s Hosts)

- [ ] `observability-agent` Ansible role — node_exporter, cAdvisor, Alloy
- [ ] Deploy to `debian-docker`, `ionos_vps`, `pve`
- [ ] Alloy River config (`alloy-config.river.j2`) — ship logs to Loki
- [ ] Docker socket integration on `debian-docker` and `ionos_vps` for container metrics

### ntfy — Redundant Alerting

- [ ] Deploy ntfy on `debian-docker` and `ionos_vps` (independent instances)
- [ ] Subscribe phone to both on same topic — redundant delivery
- [ ] Expose via Caddy at `ntfy.potterman.party`

### Security Scanning

- [ ] Add Trivy to `potter-ci-lint` CI image — image scanning, blocks on CRITICAL
- [ ] Trivy scheduled scans via Ansible systemd timer — `trivy fs /` per host, JSON → Loki via Alloy
- [ ] Trivy per-host CVE dashboard in Grafana
- [ ] Cosign image signing — after Trivy is stable
- [ ] Infracost / Checkov — cost estimation and Terraform security misconfiguration scanning

### Renovate & Container Lifecycle

- [ ] Deploy Renovate on Forgejo — `.renovaterc.json`, custom `fileMatch` for `services.yml`
- [ ] Forgejo Action on schedule
- [ ] Automated pipeline: Renovate PR → lint → merge → Ansible redeploy
- [ ] Move hardcoded PostgreSQL and Redis versions in `authentik_compose.yaml.j2` to `services.yml`
- [ ] Pin all tool versions in `potter-ci-lint` Dockerfile

### GitLab

- [ ] Deploy GitLab CE on `debian-docker` via Ansible role (post `debian-docker` rebuild)
  - [ ] Version-pinned in `services.yml`, exposed at `gitlab.potterman.party`
  - [ ] `gitlab.rb` templated via Jinja2 — external URL, vaulted secrets
  - [ ] GitLab Runner as separate container, Docker executor
  - [ ] Push mirrors from Forgejo → GitLab CE
  - [ ] Wire GitLab CE to Authentik SSO via OIDC
- [ ] Mirror selected repos to gitlab.com for external visibility
- [ ] Write `.gitlab-ci.yml` equivalents of Forgejo lint pipeline
- [ ] Register self-hosted runner on gitlab.com to avoid shared runner limits
- [ ] Document Forgejo Actions vs GitLab CI/CD syntax differences in MkDocs
- [ ] Terraform state backend moves to GitLab (built-in, free) — replaces GitHub

### ArgoCD

- [ ] Deploy ArgoCD on K3s via Ansible bootstrap (one-time)
- [ ] Authentik OIDC integration
- [ ] Migrate K3s workloads from Ansible-pushed to Git-pulled reconciliation
- [ ] Wrap Garage and future K3s services in Helm/Kustomize for ArgoCD management

### Glance — Security & News Dashboard

- [ ] Deploy Glance on K3s at `glance.potterman.party`
- [ ] GitHub Security Advisory RSS feeds per tracked service (build list organically)
- [ ] CVE feeds, IT security news, financial/game industry news

---

## Phase 4: Backups, Disaster Recovery & Resilience

### Backups

- [ ] Restic on all hosts via Ansible — encrypted, deduplicated
- [ ] Offsite target: GitLab or VPS
- [ ] pg_dump for Authentik and Firefly — daily, Ansible managed
- [ ] Seafile data backup from `ionos_vps` — currently most exposed
- [ ] Seafile → Garage S3 backend for NAS overflow
- [ ] Hybrid backup: VPS Seafile mirrors to local OMV NAS
- [ ] Rclone for offsite backup staging

### Disaster Recovery

- [ ] Ansible backup of critical PVE/PBS `/etc/` configs to NAS
- [ ] Automate PBS verification
- [ ] Terraform blueprints — finalize to recreate VM shells on fresh hardware
- [ ] Disaster recovery runbook in MkDocs — total-melt scenario
- [ ] Architecture diagram — full request flow, SPOFs, component dependencies (Mermaid)

### Host Rebuilds (Planned Migration Windows)

- [ ] `debian-docker` rebuild from cloud-init template
  - [ ] Migrate all Docker volumes and data
  - [ ] PBS snapshot before cutover
  - [ ] Terraform-manage post-rebuild
- [ ] `OMV-NAS` — evaluate replacement (TBD) during rebuild window, then Terraform-manage

---

## Phase 5: Terraform & Infrastructure Expansion

### Terraform

- [x] `ansible-main` LXC 105 — module-managed
- [x] `k3s-node1` VM 201 — module-managed
- [x] `pve-wings-vm-01` VM 202 — module-managed
- [ ] `debian-docker` VM 100 — post rebuild
- [ ] `OMV-NAS` VM 101 — post rebuild/replacement
- [ ] Fix `ipv4_address` interpolation bug in both VM and LXC modules
- [ ] Molecule — test Ansible roles in ephemeral Docker containers

### Multi-Cloud (Learning)

- [ ] **Azure** — Free Tier account, Terraform VM, VNet, NSG, ZeroTier mesh join
- [ ] **AWS** — Free Tier account, Terraform EC2, VPC, S3 remote state with DynamoDB locking
- [ ] Practice secret rotation workflows
- [ ] Evaluate HashiCorp Vault or Mozilla SOPS for dynamic secret injection

### IONOS VPS

- [ ] Contract renews 04/07/2026 — evaluate and roll over
- [ ] Ansible-managed only, no Terraform (no API access on VPS Linux M tier)
- [ ] Stalwart Mail deployment when ready — SPF/DKIM/DMARC, PTR record, replace Cloudflare Email Routing
- [ ] Fluxer — deploy when self-hosting opens

---

## Phase 6: Advanced Kubernetes & Platform Engineering

- [ ] Helm — convert Garage manifests to Helm chart as learning exercise
- [ ] Migrate stateless services to K3s after observability proves cluster stability
- [ ] K8s NetworkPolicies for pod-level isolation
- [ ] Second K3s node for HA and scheduling practice
- [ ] Database replication patterns (PostgreSQL, MariaDB)

---

## Phase 7: Documentation

- [ ] Onboarding documentation — infrastructure description, Git methodology, network topology
- [ ] Runbooks — proactive troubleshooting decision trees per critical service
- [ ] Capacity planning — resource usage trends and growth projections
- [ ] Evaluate Zensical once stable — migrate from MkDocs if warranted

---

## Backlog — No Timeline

### Enterprise Windows & Hybrid Identity

- [ ] Terraform Windows Server 2022/2025 VM on Proxmox
- [ ] Active Directory Domain Services (`corp.potterman.party`)
- [ ] Azure AD Connect for hybrid identity sync
- [ ] PowerShell endpoint bootstrapping via Winget
- [ ] Microsoft 365 automation via Graph API

### Network Segmentation

- [ ] OPNsense deployment for VLAN segmentation
- [ ] Separate trust zones for DNS, media, application workloads

### High Availability

- [ ] Second `debian-docker` VM for Docker-level HA with Caddy load balancing
- [ ] Database replication patterns

### Enterprise Identity Federation

- [ ] Federate Authentik with Microsoft Entra ID via SAML/OIDC

### Shelved — Revisit Later

- [ ] Caddyfile Jinja2 loop automation — `services.yml` schema groundwork done, automation deferred until service volume warrants it
