# Troubleshooting | Linux/CachyOS

### Issue: CachyOS hangs for 90 seconds during shutdown sequence 2026-01-27

**Root Cause**: See logs.

```{ .text title="journalctl -b 1&3 -l --lines=500" linenums="1" hl_lines="8 9 17 16" }
sty 28 03:00:04 potterman systemd[1]: ananicy-cpp.service: Deactivated successfully.
sty 28 03:00:04 potterman systemd[1]: Stopped Ananicy-Cpp - ANother Auto NICe daemon in C++.
sty 28 03:00:05 potterman systemd[1]: zerotier-one.service: Deactivated successfully.
sty 28 03:00:05 potterman systemd[1]: Stopped ZeroTier One.
sty 28 03:00:05 potterman systemd[1]: zerotier-one.service: Consumed 1.199s CPU time over 1h 30>
sty 28 03:00:05 potterman systemd[1]: Stopped target Network is Online.
sty 28 03:00:05 potterman systemd[1]: NetworkManager-wait-online.service: Deactivated successfu>
sty 28 03:00:05 potterman systemd[1]: Stopped Network Manager Wait Online.
sty 28 03:01:33 potterman systemd[1389]: app-Alacritty@a9d8a25c4fb7426d90f32796ae47ca0e.service>
sty 28 03:01:33 potterman systemd[1389]: app-Alacritty@a9d8a25c4fb7426d90f32796ae47ca0e.service>
sty 28 03:01:33 potterman systemd[1389]: app-Alacritty@a9d8a25c4fb7426d90f32796ae47ca0e.service>
sty 28 03:01:33 potterman systemd[1389]: Stopped Alacritty - Terminal.


sty 27 01:56:25 potterman systemd[1361]: Stopped KDE Window Manager.
sty 27 01:56:25 potterman systemd[1361]: plasma-kwin_wayland.service: Consumed 1h 8min 59.217s >
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@a2121772abfa4c87888eb8a249c7ccf8.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@a2121772abfa4c87888eb8a249c7ccf8.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@4e0415bcfaa14bbe90775ef1c4e11d83.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@4e0415bcfaa14bbe90775ef1c4e11d83.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@20cafd1889df4377bbbc97b8b2ae52c9.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@20cafd1889df4377bbbc97b8b2ae52c9.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@1c32db99ae9741d0bf9f507717730d03.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@1c32db99ae9741d0bf9f507717730d03.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@dfcc4576980c42268bcfa4c3c7a846ed.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@dfcc4576980c42268bcfa4c3c7a846ed.service>
sty 27 01:57:54 potterman systemd[1361]: app-Alacritty@4e0415bcfaa14bbe90775ef1c4e11d83.service>
sty 27 01:57:54 potterman systemd[1361]: Stopped Alacritty - Terminal.
```

Highlighted lines happen exactly 90 seconds apart. That was the `DefaultTimeoutStopSec` in `/etc/systemd/user.conf`.

**Fix**: I've changed the value from the default 90 seconds to 10. After that it is necessary to run `systemctl daemon-reload` to apply the changes. Shutdown and reboot sequences are now in line with my expectations.

**Notes:** It is possible that there is a better way to fix it, either by setting up a macro that kills all Alacritty sessions in one go, after pressing the "Shutdown" button or some other way. I'll look into that later, for now I'm satisfied with this result.