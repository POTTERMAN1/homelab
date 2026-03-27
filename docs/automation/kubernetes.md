# Kubernetes (K3s)

The homelab runs a lightweight **K3s** Kubernetes cluster for cloud-native workloads that benefit from container orchestration, persistent storage abstraction, and service discovery.

## Cluster Overview

* **Distribution:** K3s (fully certified Kubernetes, single binary)
* **Nodes:** 1 control-plane node (`k3s-01`, VM 201, `192.168.2.201`)
* **Provisioned by:** Terraform `proxmox-vm` module, configured by Ansible `common` role
* **Ingress Controller:** Traefik (bundled with K3s), with Caddy handling external TLS termination

## Deployed Workloads

### Garage — S3-Compatible Object Storage

Garage replaces the now-archived MinIO project as the self-hosted S3 endpoint. It provides overflow storage for Seafile and a general-purpose object store for the homelab.

**Kubernetes Resources:**

* **Namespace:** `garage`
* **ConfigMap:** `garage-config` - holds `garage.toml` configuration (gitignored due to embedded secrets)
* **Secret:** `garage-secrets` - RPC secret and admin API token
* **PersistentVolume (metadata):** Local SSD storage at `/var/lib/garage/meta` for fast metadata lookups
* **PersistentVolume (data):** NAS-backed storage at `/mnt/NAS_ZFS/garage-data` for bulk object data
* **Deployment:** Single replica running `dxflrs/garage:v2.2.0` with resource limits (500m-1000m CPU, 512Mi-1Gi RAM)
* **Service:** NodePort exposing S3 API on port 30900 and admin API on port 30903

**External Access:** Caddy reverse proxy routes `s3.potterman.party` to `k3s-node1:30900` over ZeroTier.

## Storage Architecture

Garage separates metadata (small, frequent reads) from bulk data (large, sequential reads):

* **Metadata:** Stored on the K3s node's local disk (`hostPath`) for low-latency access
* **Data:** Stored on the OMV NAS via NFS mount (`hostPath` pointing at `/mnt/NAS_ZFS/garage-data`), providing 1TB of allocated capacity with room to grow

## Manifest Organization

All Kubernetes manifests are stored in `kubernetes/garage/` and applied manually via `kubectl`. The `configmap.yaml` is gitignored since it contains secrets embedded in the TOML configuration.

```bash
kubernetes/garage/
├── namespace.yaml
├── configmap.yaml    # gitignored (contains secrets)
├── storage.yaml      # PV + PVC definitions
├── deployment.yaml
└── service.yaml
```

## Future Plans

* **Ingress:** Currently using NodePort + Caddy. Native K8s Ingress via Traefik is available but not yet configured.
* **GitOps:** Evaluate ArgoCD or FluxCD for automatic manifest synchronization from Git.
* **Additional workloads:** Migrate stateless services from Docker to Kubernetes as confidence grows.
