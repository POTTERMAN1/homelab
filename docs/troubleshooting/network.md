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