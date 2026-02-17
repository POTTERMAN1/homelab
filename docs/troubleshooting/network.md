# Troubleshooting | Network

### Issue: Asymmetric Routing / Gateway Conflict (ZeroTier) - 2026-01-28

**Symptoms:**
- Unable to reach CachyOS (.50) from ansible-main.
- Pings to 192.168.2.50 were router through my ISP gateway (192.168.2.254), instead of the ZeroTier Interface.

**Diagnostics:**: Running `ip route` showed that the default gateway was intercepting traffic destined for the ZeroTier because the metric for the physical interface was lower than the virtual one.

**Resolution:**
1. Verified the ZeroTier interface status: `zerotier-cli listnetworks`
``` 
potterman@ansible-main:~/git/homelab$ sudo zerotier-cli peers
200 peers
<ztaddr>   <ver>  <role> <lat> <link>   
12afsa13 1.15.3 LEAF     156 DIRECT   
778fasf1 -      PLANET   154 DIRECT   
caf32144 -      PLANET    49 DIRECT   
cae11244 -      PLANET   189 DIRECT   
cafd3117 -      PLANET   283 DIRECT   
```

2. Adjusted the route metric to ensure the `zt` interface takes precedence for the `192.168.192.0/24' range.
3. (Optional) Added a static route if the managed route wasn't pushed correctly by the zt controller.
```bash
sudo ip route add 192.168.192.0/24 dev zt0 proto static metric 50
```

## IONOS VPS: Hardware Firewall Blocking External Traffic

**Symptom:** Docker containers (like TeamSpeak) are running, and `ss -ulpn` shows ports are open and listening on `0.0.0.0`, but external connections (from the public internet) time out or fail.

**Root Cause:** IONOS places an External Hardware Firewall in front of all VPS instances. By default, this firewall drops all incoming traffic except for SSH (Port 22). OS-level firewall rules (`ufw`, `iptables`) or Docker port mappings will not bypass this.

**Resolution:**
Currently, this requires manual intervention via the IONOS Cloud Panel:
1. Log into the IONOS Cloud Panel.
2. Navigate to **Network > Firewall Policies**.
3. Select the active policy for the VPS and manually add the required ports (e.g., UDP 9987 for TeamSpeak Voice, TCP 30033 for File Transfer).

*Note: This is slated to be automated in Phase 2 using the `ionoscloud.cloud_api.firewallrule` Ansible module once API tokens are properly vaulted.*