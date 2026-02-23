# Infrastructure Overview

Welcome to the architectural documentation for my homelab. This project serves as a highly available, private cloud environment built entirely on **GitOps principles** and **Infrastructure as Code (IaC)**.

## Core Philosophy
The infrastructure is designed with immutability and automation in mind. Manual server configuration is strictly prohibited. If a server dies, it can be entirely reprovisioned and configured via automated pipelines.

* **Provisioning:** Bare-metal nodes and Virtual Machines are provisioned using **Terraform** via the Proxmox API.
* **Configuration:** Operating systems, Docker engines, and microservices are configured using modular **Ansible Roles**.
* **Deployment:** All code is pushed to a local **Forgejo** instance, triggering CI/CD pipelines that lint the code and mirror it to **GitHub**.
* **Networking:** Internal traffic is secured over a **ZeroTier** Software-Defined Network (SDN), creating a "Darknet" mesh that requires no open public ports.

## Hardware & Virtualization
The core of the environment runs on a **Proxmox VE (PVE)** cluster. 
Instead of heavy VMs, the architecture heavily favors lightweight LXC containers and VM Docker hosts to maximize resource efficiency.

## The GitOps Lifecycle
1. Code changes (Ansible, Terraform, or Docs) are pushed to the `staging` branch on Forgejo.
2. A Forgejo Action triggers `yamllint` and `ansible-lint` to validate the code.
3. Upon a successful merge to `main`, the code is mirrored to GitHub.
4. GitHub Actions automatically builds this MkDocs site and deploys it to GitHub Pages.

---
*Navigate to the **Automation** section to view the raw infrastructure code.*