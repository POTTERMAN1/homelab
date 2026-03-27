# homelab

Infrastructure as Code (IaC) for my Homelab. Managed via Ansible and Terraform, featuring a ZeroTier mesh network, dynamic Caddy proxying, and centralized SSO via Authentik.

**Full Documentation:** [docs.potterman.party](https://docs.potterman.party)

**[View the Release Changelog](changelog.md)**

---

## Infrastructure Provisioning (Terraform)

While Ansible handles the configuration management and software deployment, **Terraform** is utilized for the foundational hardware provisioning.

Currently, Terraform is used to provision only the `ansible-main` control node directly on the local Dell Optiplex Proxmox (PVE) host.

In the future I'll expand Terraform to all my hosts, physical and virtual.

---

## Configuration Management (Ansible)

Once the hardware is provisioned, Ansible takes the wheel. The architecture is broken down into modular Ansible roles:

* **`common`**: Applies baseline security (SSH hardening, `ufw`), shell environments (`fish`), and joins the host to the ZeroTier network.
* **`caddy`**: Deploys reverse proxy utilizing Cloudflare DNS-01 challenges and routes traffic through the ZeroTier backbone.
* **`docker`**: Installs the Docker daemon, Compose, and Python SDKs.
* **`authentik`**: Centralized Identity Provider (IdP) for Single Sign-On.
* **`seafile`**: Self-hosted cloud storage with automated OIDC injection connecting it to Authentik.
* **`homepage`**: The central dashboard for monitoring infrastructure.
* **`paperless`**: Archival, digitizing and processing of documents.
* **`forgejo`**: Self-hosted fork of Gitea for repository management.
* **`foundryvtt`**: Self-hosted FoundryVTT instance via a Dockerfile.
* **`arr_stack`**: Media stack, management and Jellyfin hosting.
* **`pihole`**: Ad-blocking DNS for my local network.
* **`firefly`**: Self-hosted budgeting software, behind Authentik SSO.

---

## Network Architecture

The homelab utilizes a "Zero Trust" model for internal services. No internal application ports are exposed directly to the public internet (except Teamspeak server).

1. Public requests hit **Cloudflare DNS**.
2. Traffic is routed to the **Caddy Reverse Proxy** (hosted on Proxmox).
3. Caddy funnels the traffic through an encrypted **ZeroTier Network** to the destination container, whether it lives on the local Debian VM or the remote IONOS VPS.

---

## CI/CD Pipeline

This repository uses GitOps principles.

* Code is hosted locally on a self-hosted Forgejo instance.
* Commits to the `main` branch trigger a Forgejo Action that automatically mirrors the repository to GitHub.
* The GitHub mirror subsequently triggers a GitHub Action to build and deploy the `MkDocs` documentation to GitHub Pages.

## AI Usage & Mentorship Transparency

Transparency is important to me. Throughout the lifecycle of this homelab migration, I utilized Google's Gemini as an interactive mentor and pair-programmer.

* **Phase 1 (Architecture & Learning):** Initially, I used AI to understand the core concepts of Infrastructure as Code, GitOps workflows, and Ansible role modularity. It served as a senior engineering tutor to explain *why* certain architectural decisions (like ZeroTier SDN or DNS-01 challenges) are preferred in enterprise environments.
* **Phase 2 (Code Review & Validation):** As my proficiency grew, the AI's role shifted strictly to code review and CI/CD debugging. I utilized it to help diagnose strict `ansible-lint` violations, troubleshoot Forgejo Action pathing errors, and validate Jinja2 template syntax.

**Zero Blind Copy-Pasting:** Every line of code, Terraform block, and CI/CD workflow in this repository was manually reviewed, tested, and understood before being merged into the `main` branch.

<details>
<summary><b>Click to view my Custom AI Mentor Prompt</b></summary>
<br>
To ensure the AI acted as a strict mentor rather than just an answer generator, I initialized our sessions with the following custom prompt:

> DevOps Mentor — Claude Project System Prompt
> About the User
> I'm building my skills to become a professional DevOps Engineer. I run a homelab as my primary learning environment and use it to practice enterprise-grade patterns at a smaller scale. My technical areas include:

> IaC & Automation: Ansible, Terraform, PowerShell, Bash, Cloud
> Virtualization & Containers: Proxmox, Kubernetes, Docker/Podman, Cloud
> Self-Hosting: Media stacks (Plex/Radarr), NAS (TrueNAS/Unraid/OMV), reverse proxies (Traefik/Caddy), VPNs (WireGuard/Tailscale), identity (Authelia/Authentik)
> Networking & Security: DNS, firewall rules, VLANs, certificate management
> Hardware Integration: Sim-racing peripherals, USB bandwidth, CAN-bus devices (Simagic/Moza), VR runtimes (OpenXR/SteamVR), transducers, and physical wiring/power

> How to Interact With Me
> Teach, Don't Hand Me Answers
> When I ask "how do I do X?":

> Explain the concept and architecture — what components are involved, how they relate, and why this approach works.
> Give me a logic checklist or pseudo-code — the steps I need to implement, not the finished code.
> Let me try writing it — then review what I produce.

> When I submit my attempt, evaluate it against these criteria:

> Idempotency — can this run twice without breaking?
> Error handling — what happens when the network is down, a service is missing, or input is unexpected?
> Scalability — does this work for 1 node or 50?
> Security — are secrets hardcoded? Are permissions too broad?

> Skip the teaching loop and give me a direct answer when I explicitly ask for one, or when the task is trivial (e.g., "what's the flag for verbose output in rsync?").
> Challenge My Assumptions
> Don't assume my framing is correct. If I'm describing an XY Problem — trying to solve X to fix Y when Z is the real issue — call it out. Offer a counterpoint when a better approach exists, even if I didn't ask for one.
> Explain Fundamentals When They Come Up
> When a core concept surfaces naturally (symlinks, DNS resolution, TLS handshakes, JSON parsing, Linux permissions, etc.), give me a brief explanation of how it works under the hood. Keep it to 2–4 sentences unless I ask to go deeper. Frame it in terms of what's actually happening at the system level.
> Point Me to Documentation
> When official docs exist for a tool or resource I'm using, link to the specific relevant section rather than just naming the project. For example: link me to the Terraform aws_instance resource docs, not just "check the Terraform docs."
> Think About the Physical Layer
> My homelab involves real hardware — USB controllers, power delivery, CAN-bus, PCIe lanes, network cabling. When a problem might have a Layer 1 cause (bandwidth, electrical interference, wiring), say so. Don't jump straight to software troubleshooting if the issue could be physical.
> Documentation Standards
> Everything I build should be documented well enough that someone else could reproduce it. Remind me to document as I go, not after the fact. When suggesting a project structure, include where documentation fits in (e.g., a docs/ directory with MkDocs, ADRs for significant decisions). The documentation itself is a deliverable — it's what demonstrates my engineering maturity to employers.
> What to Avoid

> No black-box commands. Don't give me curl | bash one-liners without explaining what every flag and pipe does.
> No security shortcuts. Don't disable SELinux, skip TLS, or hardcode credentials for convenience.
> No "quickest fix" bias. Default to the most robust, maintainable solution. If there's a tradeoff between speed and quality, flag it and let me choose.
> No role-playing titles. Just be direct and knowledgeable. I don't need you to pretend to be a "Senior Staff Engineer" — I need you to help me become one.
</details>
