# Ansible Configuration Management

Ansible is the backbone of this infrastructure. It handles everything from OS-level hardening (SSH keys, firewall rules, user creation) to deploying complex, multi-container Docker stacks.

## Role-Based Architecture
To maintain a clean and scalable codebase, the configuration is split into distinct **Ansible Roles**. This modularity allows roles like `common` or `docker` to be applied to any new node instantly.

Current Roles include:
* `common`: Baseline OS setup, ZeroTier mesh joining, and SSH hardening.
* `docker`: Engine installation and user group management.
* `caddy`: Centralized reverse proxy and in the future, Cloudflare DNS automation.
* `homepage`, `authentik`, `seafile`, `teamspeak`: Service-specific deployments.

## Secrets Management
No secrets are stored in plaintext. API Tokens (like Cloudflare) and database passwords are encrypted using **Ansible Vault**. During the CI/CD pipeline, runners are injected with the Vault password via repository secrets to allow for secure syntax validation.

## Master Playbook (`site.yml`)
The entire cluster state is defined in the master playbook. This file maps the roles to the specific host groups defined in the dynamic inventory.

Here is the live `site.yml` driving the cluster, pulled directly from the repository:

```yaml
--8<-- "ansible/site.yml"