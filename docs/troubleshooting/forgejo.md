# Troubleshooting | Forgejo


## Issue: Forgejo SSH Port Conflict (2222 vs 22) - 2026-01-26

**Symptom**: Forgejo (Docker) and the Host (Debian) both fighting for Port 22.
**Fix:**:\ 
Mapped Forgejo SSH to 2222 in docker-compose.yml.\
**User Config**: Updated ~/.ssh/config on CachyOS to use Port 2222 for the git user specifically for the Forgejo host.

## Issue: Repository Out of Sync Warning 2026-01-26

**Symptom**: Git hooks on disk didn't trigger the database update, leading to "Database representation out of synchronization."

**Fix**: Ran Admin Dashboard > Operations > Synchronize repository hooks in the Forgejo Web UI.