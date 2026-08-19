---
name: forgejo-maintainer
description: Administer Forgejo or Gitea installations, including upgrades, backups, migrations, repository access, and Actions runners. Use for application-specific operations, not general Linux host troubleshooting.
---

# forgejo-maintainer

## Workflow

1. Establish the deployment method, Forgejo version, database, storage paths,
   configuration, and runner topology.
2. Separate application failures from host, network, container, and reverse
   proxy failures; use the narrower skill for substantial work in those layers.
3. Determine impact to Git, web, SSH, packages, and Actions, then create
   rollback with database and data backups.
4. Make the smallest application-specific change and validate every affected
   access path.

## Diagnostics

```bash
systemctl status forgejo
journalctl -xeu forgejo
forgejo --version
df -h
findmnt
ss -tulpn
ssh -T git@<host>
curl -I <root-url>
```

## Safety Rules

- Never upgrade before taking database and data backups.
- Never trust a backup policy until restore has been tested.
- Never expose runner registration tokens in logs or docs.
- Preserve `app.ini`, repositories, LFS objects, attachments, packages, and custom templates.
- Isolate Actions runners by trust boundary.

## Validation

- Web login and repository browsing work.
- HTTPS clone and SSH clone work.
- Push and pull work for a test repository.
- Actions runners register and run a small job when applicable.
- Backup artifacts exist and restore steps are documented.
