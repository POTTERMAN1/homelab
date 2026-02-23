## Core Philosophy
1. **Infrastructure as Code (IaC):** Every host, from the Dell Optiplex server to the remote IONOS VPS, is configured via Ansible. No manual configuration is permitted on target nodes.
2. **Zero Trust Networking:** No internal service ports are exposed to the public internet (EXCEPT TEAMSPEAK 6 SERVER). All cross-node communication (Proxmox ↔ VPS ↔ NAS) routes through an encrypted ZeroTier mesh network.
3. **Single Sign-On:** Authentik acts as the central Identity Provider (IdP). Services like Seafile delegate authentication via OIDC.

## Network Topology

This is very unreadable and first draft of my Network topology using Mermaid.js
I'll whip out a better graph using draw.io in the future

```mermaid
graph TD
    User((User)) -->|HTTPS| CF[Cloudflare DNS]

    subgraph "Public Internet"
        CF -->|A Record| IONOS[IONOS VPS]
        CF -->|CNAME| PVE_CADDY[Dell Optiplex: Caddy]
    end

    subgraph "Management Layer"
        ANSI[Ansible Controller] -->|SSH| PVE_CADDY
        ANSI -->|SSH| IONOS
        ANSI -->|SSH| DOCKER_VM[Debian VM]
    end

    ZT((ZeroTier Mesh))
    IONOS <--> ZT
    PVE_CADDY <--> ZT
    DOCKER_VM <--> ZT
    NAS[OMV NAS] <--> ZT

    subgraph "Local Datacenter (Proxmox)"
        PVE_CADDY -->|ZT Proxy| DOCKER_VM
        DOCKER_VM --> AUTH[Authentik SSO]
        DOCKER_VM --> FORGE[Forgejo]
        DOCKER_VM --> PIH[Pihole]
        DOCKER_VM --> HOME[Homepage]
        PVE_CADDY -->|ZT Proxy| NAS
    end

    subgraph "Remote Cloud (IONOS)"
        IONOS --> TS[TeamSpeak 6]
        IONOS --> SEA[Seafile]
        SEA -.->|OIDC| AUTH
    end