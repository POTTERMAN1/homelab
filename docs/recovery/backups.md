# Backups & Proxmox Backup Server (PBS)

While GitOps and Infrastructure as Code (IaC) ensure that the *configuration* of the homelab can be rebuilt from scratch at any time, persistent data (like databases, user uploads, and logs) requires dedicated storage protection.

## Current Backup Strategy
The infrastructure relies on **Proxmox Backup Server (PBS)** for complete state preservation.

* **Frequency:** Daily automated backups.
* **Scope:** All virtual machines (VMs) and LXC containers hosted on the Proxmox cluster.
* **Type:** Incremental, snapshot-based backups.

## The Role of PBS in the Stack
PBS acts as the primary safety net against catastrophic data loss or accidental volume deletion. If a Docker container's persistent volume is corrupted, the entire VM host can be rolled back to the previous night's state in minutes, without needing to trigger the full Ansible deployment pipeline.

*Note: Off-site data replication (e.g., S3 cloud backups) is slated for a future roadmap phase.*