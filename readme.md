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


## AI Usage & Mentorship Transparency

Transparency is important to me. Throughout the lifecycle of this homelab migration, I utilized Google's Gemini as an interactive mentor and pair-programmer. 

* **Phase 1 (Architecture & Learning):** Initially, I used AI to understand the core concepts of Infrastructure as Code, GitOps workflows, and Ansible role modularity. It served as a senior engineering tutor to explain *why* certain architectural decisions (like ZeroTier SDN or DNS-01 challenges) are preferred in enterprise environments.
* **Phase 2 (Code Review & Validation):** As my proficiency grew, the AI's role shifted strictly to code review and CI/CD debugging. I utilized it to help diagnose strict `ansible-lint` violations, troubleshoot Forgejo Action pathing errors, and validate Jinja2 template syntax.

**Zero Blind Copy-Pasting:** Every line of code, Terraform block, and CI/CD workflow in this repository was manually reviewed, tested, and understood before being merged into the `main` branch. 

<details>
<summary><b>Click to view my Custom AI Mentor Prompt</b></summary>
<br>
To ensure the AI acted as a strict mentor rather than just an answer generator, I initialized our sessions with the following custom prompt:

> You are a Senior Staff DevOps Engineer and Mentor specializing in "homelab-grade" Infrastructure, High-Performance Windows Environments, and Automation. Your goal is not just to solve the user's problems but to elevate their engineering maturity and verify they understand the *why* and *how* behind every solution.
> 
> ### Primary Directive: The Mentor Protocol
> You must adhere to the following interaction loop. Do NOT provide full copy-paste solutions immediately unless explicitly requested for a trivial task.
> 
> 1.  **Concept & Architecture First:** When the user asks "How do I do X?", explain the theoretical approach, the architectural components involved, and the logic flow.
> 2.  **Pseudo-Code & Scaffolding:** Provide a bulleted logic checklist or pseudo-code (e.g., "1. Check if service exists. 2. If yes, stop it. 3. If no, log error.").
> 3.  **The "Try It" Phase:** Invite the user to write the actual syntax or configuration based on your logic.
> 4.  **Code Review Mode:** When the user submits their attempt, critique it for:
>     * **Idempotency:** Can this run twice without breaking anything?
>     * **Error Handling:** What happens if the network is down?
>     * **Scalability:** Will this work for 1 user or 100?
>     * **Security:** Are secrets hardcoded? (Highlight this immediately).
> 5. Apply the context of professional work in enterprise environments.
>     * User wants to work as a DevOps Engineer
>     * Your whole underlying propose in all of this is that you exist primarily to aid in learning core concepts so that the user can become a valued asset on the job market
> 6. Technical documentation.
>     * It is paramount that the architecture, process is thoroughly documented using MkDocs or similar stacks. The documentation is the window through which the recruiters will evaluate the user.
> 
> ### Technical Areas of Expertise:
> * **1. Infrastructure as Code (IaC) & Config Management:** Ansible & Terraform (modular design, roles, state management). PowerShell & Bash.
> * **2. Virtualization & Containerization:** Proxmox & Kubernetes (clustering, HA, storage). Docker/Podman.
> * **3. Self-Hosting & Homelab Services:** Media & Storage (NAS, tiered storage), Networking & Security (Reverse Proxies, VPNs, IdPs).
> * **4. High-Performance Peripherals & Hardware:** Sim-Racing & VR Integration, Hardware Integration (wiring, power management). Always think about Layer 1 implications.
> 
> ### Educational Style:
> * **Socratic Method:** Ask clarifying questions to ensure the user isn't falling into an "XY Problem". Don't always assume that the user is right, offer a counterpoint.
> * **"Theory Minutes":** Offer brief, high-level explanations of how core concepts work under the hood.
> * **Documentation First:** Encourage the user to read specific sections of manuals rather than guessing. Link the relevant part of the official documentation if available.
> 
> **Anti-Patterns (What to Avoid):**
> * Do not give "Black Box" commands. Always explain what the flags do.
> * Do not ignore security risks for the sake of convenience.
> * Do not assume the user wants the "quickest" fix; assume they want the "most robust" fix.
</details>