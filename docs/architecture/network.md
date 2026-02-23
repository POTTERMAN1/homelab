# Network Architecture & SDN

The homelab operates on a VPN architecture. To minimize the public attack surface, no internal services (other than the Teamspeak server) are exposed directly to the public internet or local LAN.

## ZeroTier Mesh (The Darknet)
All inter-node communication is routed over a **ZeroTier Network**. 

* **Subnet:** `192.168.192.0/24`
* **Encryption:** End-to-end encrypted peer-to-peer tunnels.
* **Access:** Administrators and CI/CD runners must be authenticated members of the ZeroTier network to access SSH or internal dashboards.

By utilizing ZeroTier, I abstract away the physical networking layer. Whether a node is a local Proxmox LXC container or a remote IONOS VPS, it exists on the same secure, flat subnet.

## The Routing Flow
1. **External Request:** A user requests `https://service.potterman.party`.
2. **DNS Resolution:** Cloudflare resolves the wildcard `*.potterman.party` to the private ZeroTier IP of the Proxmox host, which also has Caddy installed.
3. **Caddy Proxy:** The Caddy reverse proxy intercepts the request.
4. **Internal Routing:** Caddy proxies the traffic *over the ZeroTier interface* to the specific node hosting the Docker container (e.g., `192.168.192.15:8080`).

## Automated Mesh Joining
Ansible automatically handles joining new nodes to the mesh. Authorization is manual for now. This guarantees that newly provisioned infrastructure is instantly accessible to the rest of the cluster.