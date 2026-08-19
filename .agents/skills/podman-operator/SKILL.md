---
name: podman-operator
description: Build and operate Podman containers and Quadlet services, including rootless deployment, networking, volumes, systemd integration, and troubleshooting.
---

# podman-operator

## Workflow

1. Gather container, image, network, volume, and systemd state.
2. Separate container lifecycle or Quadlet failures from underlying host,
   storage, DNS, and application failures; route substantial work in those
   layers to the narrower skill.
3. Determine whether rootless or rootful operation is required and create
   rollback using previous image tags, unit files, and volume backups.
4. Implement the smallest Podman-specific change and validate it through both
   systemd and Podman.

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
