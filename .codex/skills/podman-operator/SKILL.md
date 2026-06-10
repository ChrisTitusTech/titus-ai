---
name: podman-operator
description: Build, deploy, and troubleshoot Podman services, Quadlet units, rootless containers, container networking, volumes, systemd integration, and production container operations. Use when Codex is asked to convert compose files, write Quadlet units, debug Podman networking or volumes, or prepare repeatable container deployment steps.
---

# podman-operator

## Workflow

1. Gather container, image, network, volume, and systemd state.
2. Determine whether rootless or rootful operation is required.
3. Create rollback using previous image tags, unit files, and volume backups.
4. Implement the smallest Quadlet or Podman change.
5. Validate container health through systemd and Podman.

## Diagnostics

```bash
podman ps -a
podman images
podman logs <container>
podman inspect <container>
podman network ls
podman volume ls
systemctl --user status <unit>
journalctl --user -xeu <unit>
loginctl show-user <user>
```

## Safety Rules

- Prefer Quadlet for persistent services.
- Prefer rootless containers unless host integration requires rootful operation.
- Never put secrets directly in unit files.
- Never delete volumes without explicit approval.
- Preserve SELinux labels and fix denials with targeted labels.

## Validation

- `systemctl --user status <unit>` is healthy.
- `podman ps` shows expected ports and status.
- Container logs show no startup errors.
- Published endpoints respond from the host and expected clients.
- Restart and reboot behavior match the service requirements.
