# Docker Troubleshooting

## Issue: Pi-hole Disk Shortage (/dev/shm)
**Symptom:** Pi-hole web UI displays a red warning: `Disk shortage (/dev/shm) ahead: 99% used`. DNS resolution may slow down or halt.
**Cause:** Pi-hole stores its active DNS cache in shared memory (`/dev/shm`). Docker heavily restricts this to 64MB by default, which fills up quickly on active networks.
**Fix:** 1. Add the `shm_size` directive to the Pi-hole `docker-compose.yml`:
```yaml
services:
  pihole:
    image: pihole/pihole:latest
    shm_size: "256mb" # Increases limit from 64MB