---
name: homelab-admin
description: Operate homelab infrastructure spanning networking, DNS, storage, NFS, reverse proxies, or multiple services. Use for cross-system work rather than an isolated host, application, or container problem.
---

# homelab-admin

## Workflow

1. Map the affected hosts, clients, network paths, storage dependencies, and
   service ownership before changing anything.
2. Route an isolated Linux, Forgejo, or Podman problem to its narrower skill;
   keep this skill active when multiple infrastructure layers interact.
3. For authorized changes, determine impact and prepare rollback. Before
   changes that could sever access, verify an alternate recovery path.
4. Validate the affected service, network, storage, and client paths. Inspect
   persistence configuration; reboot only within an authorized maintenance scope.

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
curl -I <url>
```

## Safety Rules

- Never destroy data without explicit approval.
- Never modify firewall or DNS blindly.
- Never change networking without rollback and out-of-band access.
- Treat storage, reverse proxy, and NFS changes as high blast-radius work.
- Prefer incremental config changes over broad rewrites.
- Keep TLS certificate verification enabled. Do not use insecure requests as
  evidence that a certificate or trust-chain problem is fixed.

## Validation

- Changed services and mounts work now and have correct persistence settings.
- Report an actual reboot test separately from configuration inspection.
- DNS resolves from expected clients.
- Reverse proxy routes to the expected backend.
- Logs show no new errors.
