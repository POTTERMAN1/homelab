# Ansible Configuration Management

Ansible is the backbone of this infrastructure. It handles everything from OS-level hardening (SSH keys, firewall rules, user creation) to deploying complex, multi-container Docker and Kubernetes stacks.

## Role-Based Architecture

To maintain a clean and scalable codebase, the configuration is split into distinct **Ansible Roles**. This modularity allows roles like `common` or `docker` to be applied to any new node instantly.

Current Roles include:

* `common`: Baseline OS setup, ZeroTier mesh joining, NFS mount to NAS, and SSH hardening.
* `docker`: Engine installation, Compose plugin, Python SDK, and user group management.
* `caddy`: Centralized reverse proxy with Cloudflare DNS-01 wildcard certificates.
* `authentik`: Centralized Identity Provider (IdP) for Single Sign-On.
* `seafile`: Self-hosted cloud storage with automated OIDC injection connecting it to Authentik.
* `homepage`: Central dashboard for monitoring infrastructure.
* `firefly`: Budget tracking application deployed behind Authentik SSO via Caddy `forward_auth`.
* `foundryvtt`: Custom-built Docker image (Node.js 22-slim) with version-pinned builds, healthcheck, and NAS-mounted user data.

## Centralized Service Configuration

All application service variables (subdomains, ports, root paths, version pins) are consolidated in a single `services.yml` file under `group_vars/all/`. This eliminates scattered variable definitions and provides a single source of truth for service configuration across all roles.

```yaml
--8<-- "ansible/inventory/group_vars/all/services.yml"
```

## Secrets Management

No secrets are stored in plaintext. API Tokens (like Cloudflare) and database passwords are encrypted using **Ansible Vault**. During the CI/CD pipeline, runners are injected with the Vault password via repository secrets to allow for secure syntax validation.

## Master Playbook (`site.yml`)

The entire cluster state is defined in the master playbook. This file maps the roles to the specific host groups defined in the inventory.

Here is the live `site.yml` driving the cluster, pulled directly from the repository:

```yaml
--8<-- "ansible/site.yml"
```
