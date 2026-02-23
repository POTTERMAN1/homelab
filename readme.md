# homelab
Infrastructure as Code (IaC) for my Homelab. Managed via Ansible and Terraform, featuring a ZeroTier mesh network, dynamic Caddy proxying, and centralized SSO via Authentik.


**Full Documentation:** [docs.potterman.party](https://docs.potterman.party)

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
* **`teamspeak`**: Teamspeak server hosted on the remote IONOS VPS.
* **`homepage`**: The central dashboard for monitoring infrastructure.

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