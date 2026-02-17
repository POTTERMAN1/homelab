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
```
## Docker API permission denied
**Symptom:**
Running `docker exec`, `docker ps`, or using the Ansible `community.docker` modules returns:
`permission denied while trying to connect to the docker API at unix:///var/run/docker.sock`

**Cause:**
The user executing the playbook (e.g., `potterman`) has not been granted access to the Docker socket.

**Resolution:**
Ensure the user is appended to the `docker` group. In Ansible, this must be done before any Docker modules run:
```yaml
- name: Ensure user is in docker group
  ansible.builtin.user:
    name: potterman
    groups: docker
    append: true
```

*Note:* If doing this manually, the user **must** log out and log back in for the group assignment to take effect.

## Container Volume Permission Errors (Log Grepping)
**Symptom:** Attempting to read logs or files inside a mounted Docker volume (e.g., `/opt/teamspeak`) from the host OS results in a `Permission denied` error, even when the user owns the parent directory.
**Root Cause:** The Docker container forces ownership of the mounted volume to match the internal user running the app (e.g., TeamSpeak uses `UID/GID 9987)`.
**Resolution:** Use Ansible to explicitly set and recurse the ownership of the bind-mount directory to match the container's UID/GID before deploying the container:
```yaml
- name: Ensure volume directory exists with correct permissions
  ansible.builtin.file:
    path: /opt/teamspeak
    state: directory
    owner: "9987"
    group: "9987"
    recurse: true
```

If you need to read the files from the host CLI later, you must use `sudo`.