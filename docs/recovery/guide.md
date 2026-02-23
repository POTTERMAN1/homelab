# The Absolute Zero Guide (Disaster Recovery)

"Absolute Zero" refers to a total loss of the primary Proxmox host or a catastrophic failure requiring a complete rebuild from bare metal. Because this environment is built on strict **GitOps principles**, recovery is highly deterministic and heavily automated.

### Recovery Paths

## Path A: State Restoration (PBS Intact)
If the Proxmox Backup Server (PBS) datastore survives the hardware failure:

* Reinstall the base Proxmox VE operating system on replacement bare-metal hardware.
* Reconnect the PBS datastore to the new Proxmox node.
* Restore the `ansible-main` control node, Forgejo, and application containers directly from the latest daily snapshot.
**Data Loss:** Minimal (up to 24 hours).

## Path B: The IaC Rebuild (PBS Lost)
If the backup server is lost, but the Git repository (safely mirrored on GitHub) survives, the infrastructure can be rebuilt from the code:

* **Provision:** Execute `terraform apply` from a local workstation to recreate the VMs and LXC containers on a fresh Proxmox host.
* **Configure:** Run the Ansible `site.yml` master playbook against the newly provisioned IP addresses.
* **Restore Routing:** Caddy and ZeroTier will automatically re-establish the internal mesh network and request new SSL certificates from Cloudflare.

**Data Loss:** High (persistent application data is lost), but the **infrastructure and services** will be fully operational, secured, and publicly routed within minutes.