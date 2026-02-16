# Caddy & Reverse Proxy Troubleshooting

### Issue: "Expected 1 zone, got 0" (Cloudflare DNS-01)
**Symptom:** Caddy fails to obtain a Let's Encrypt certificate. Logs show `adding temporary record for zone "domain.com.": expected 1 zone, got 0`.
**Root Cause:** The Cloudflare API Token didn't have specific DNS zone set.
**Fix:** 1. Go to Cloudflare Dashboard -> API Tokens.
2. Ensure permissions are exactly: **Zone:DNS:Edit** and **Zone:Zone:Read**.
3. *Crucial:* Set **Zone Resources** to **Include -> Specific Zone -> yourdomain.com** In this specific case it should be `potterman.party`.

### Issue: "Context canceled" or "Unable to unlock"
**Symptom:** Logs show `no memory of presenting a DNS record` and Caddy gets stuck in a retry loop throwing lock errors.
**Root Cause:** A race condition. Caddy crashed or was restarted by Ansible while it was in the middle of talking to Cloudflare, leaving corrupted "lock" files in its temporary directory.
**Fix:** Perform a "Deep Clean" on the Caddy state.
```bash
sudo systemctl stop caddy
sudo rm -rf /var/lib/caddy/.local/share/caddy/*
sudo systemctl start caddy
```