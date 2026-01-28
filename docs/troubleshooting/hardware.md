# Troubleshooting | Hardware

## Issue: 27.3k write errors when `zpool status` was invoked on the PVE

**Root Cause**: The SATA cable was the main and only culprit behind the issue. Using `smartctl -a` on the device has shown only ZFS errors, with no actual bad sectors on the disk.

**Fix**: Replaced the SATA cable. 

### **Baseline Verification (2026-01-28)**
- **Status:** Verified `zpool status` is healthy. After 24 and 48 hours respectively.
- **Errors:** 0 (Read, Write, Checksum).
- **Notes:** Baseline established before Phase 2 rsync migrations.

### How to Monitor
To check the status of the primary storage pools on the OMV/Proxmox nodes:
```bash
zpool status -v
```
***Further improvements*** pending Phase 3: Monitoring, Health & Notifications.