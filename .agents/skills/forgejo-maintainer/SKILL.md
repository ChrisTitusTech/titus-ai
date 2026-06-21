---
name: forgejo-maintainer
description: Maintain Forgejo and Gitea-compatible installations, repository administration, SSH access, Actions runners, backups, upgrades, migrations, and operational runbooks. Use when Codex is asked to debug Forgejo, plan upgrades, migrate from Gitea, configure runners, verify backups, or administer repositories and access.
---

# forgejo-maintainer

## Workflow

1. Gather deployment, version, database, config, runner, and storage state.
2. Determine user impact for Git, web, SSH, packages, and Actions.
3. Create rollback with database and data backups.
4. Implement the smallest admin, config, runner, or upgrade change.
5. Validate web, SSH, repository, backup, and runner behavior.

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
