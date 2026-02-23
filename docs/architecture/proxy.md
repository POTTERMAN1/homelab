# Reverse Proxy & Traffic Routing

Centralized traffic management is handled by **Caddy**. Caddy was chosen over Nginx or Traefik for its native, automatic HTTPS provisioning and its highly readable configuration syntax.

## 🔒 Automated Wildcard TLS (Cloudflare DNS-01)
To keep internal service names completely private, the infrastructure does not use HTTP-01 ACME challenges. Instead, it uses **DNS-01 challenges via the Cloudflare API**.

This allows Caddy to provision a wildcard certificate (`*.potterman.party`) without exposing the internal IP addresses or service names to public Certificate Transparency logs.

## 📜 The Caddyfile Template
In keeping with GitOps principles, the proxy configuration is managed as a Jinja2 template (`Caddyfile.j2`). Ansible dynamically populates the routing targets using the `zerotier_ip` variables assigned to each host in the inventory.S

Here is the live Caddyfile template powering the infrastructure:

```caddyfile
--8<-- "ansible/playbooks/roles/caddy/templates/Caddyfile.j2"
```
**[View the Caddy Ansible Role on GitHub](https://github.com/potterman1/homelab/tree/main/ansible/playbooks/roles/caddy)**

## Zero Downtime Reloads
When Ansible updates the Caddyfile, it utilizes systemd handlers to perform a graceful reload of the Caddy service. Active connections are maintained while the new routing rules are applied.