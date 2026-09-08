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
3. Preserve the rootless or rootful deployment model unless the task requires
   changing it. Before mutation, retain prior image identifiers and units;
   back up volume data when the operation could change or remove it.
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

Use selected `podman inspect --format` fields for the diagnosis; full inspect
output and logs can contain environment credentials. Do not expose secrets.
Use `systemctl --user` for rootless units and the system manager for rootful
units; run only the diagnostics relevant to the failure.

## Safety Rules

- Prefer Quadlet for persistent services.
- Prefer rootless containers unless host integration requires rootful operation.
- Never put secrets directly in unit files.
- Never delete volumes without explicit approval.
- Preserve SELinux labels and fix denials with targeted labels.

## Validation

- The unit is healthy in the correct systemd manager.
- `podman ps` shows expected ports and status.
- Container logs show no startup errors.
- Published endpoints respond from the host and expected clients.
- Inspect restart and boot configuration. Exercise disruptive restart or reboot
  tests only within the authorized maintenance scope and report untested paths.
