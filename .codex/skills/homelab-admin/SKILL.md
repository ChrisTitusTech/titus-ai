---
name: homelab-admin
description: Operate and troubleshoot homelab infrastructure with Rocky Linux, systemd, networking, NFS, Synology storage, DNS, reverse proxies, and storage management. Use when Codex is asked to plan maintenance, diagnose outages, change host or network configuration, document runbooks, or prepare safe commands for homelab servers.
---

# homelab-admin

## Workflow

1. Gather diagnostics.
2. Determine user impact and blast radius.
3. Create rollback.
4. Implement the smallest safe change.
5. Validate service, network, storage, and reboot persistence.

## Diagnostics

```bash
hostnamectl
ip addr
ip route
systemctl status <service>
journalctl -xeu <service>
ss -tulpn
df -h
lsblk
findmnt
dig <name>
curl -vk <url>
```

## Safety Rules

- Never destroy data without explicit approval.
- Never modify firewall or DNS blindly.
- Never change networking without rollback and out-of-band access.
- Treat storage, reverse proxy, and NFS changes as high blast-radius work.
- Prefer incremental config changes over broad rewrites.

## Validation

- Service starts now and after reboot.
- Mounts persist after reboot.
- DNS resolves from expected clients.
- Reverse proxy routes to the expected backend.
- Logs show no new errors.
