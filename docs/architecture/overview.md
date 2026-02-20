# Hybrid-Cloud Storage (NFS over ZeroTier)

To allow the IONOS VPS to store large media files directly on the local NAS, an encrypted NFS tunnel was established over the ZeroTier virtual network.

### Implementation Details
* **Network:** Traffic routes over the ZeroTier "Darknet" (`192.168.192.x`).
* **Mount Point:** `/mnt/NAS_ZFS`.
* **FSTAB Options:** * `_netdev`: Ensures the OS waits for network availability before attempting to mount.
    * `nofail`: Prevents the system from failing to boot if the NAS is temporarily unreachable.

### Ansible Task
```yaml
- name: Configure NAS Mount in fstab
  ansible.posix.mount:
    src: "192.168.192.106:/export/NAS_ZFS"
    path: /mnt/NAS_ZFS
    fstype: nfs
    opts: "defaults,_netdev,nofail" 
    state: present
```