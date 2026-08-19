---
name: linux-sysadmin
description: Diagnose and operate Linux hosts, services, packages, permissions, SELinux, firewalls, and SSH. Use for host-level work that is not primarily an application-specific or container task.
---

# linux-sysadmin

## Workflow

1. Gather host, service, resource, network, and security diagnostics.
2. Determine whether the failure is host-level or primarily belongs to a
   specialized application, container, or cross-system infrastructure skill.
3. Identify impact and recent changes, then create rollback for files,
   packages, service units, and firewall changes.
4. Implement the smallest host-level fix and validate runtime behavior, remote
   access, security policy, and boot persistence.

## Diagnostics

```bash
cat /etc/os-release
uname -a
uptime
free -h
df -h
lsblk
systemctl status <unit>
journalctl -xeu <unit>
ss -tulpn
getenforce
firewall-cmd --list-all
ufw status verbose
```

## Safety Rules

- Never disable SELinux as a default fix.
- Never rotate SSH keys or change `sshd_config` without rollback.
- Never modify firewall rules without confirming active firewall stack.
- Prefer systemd drop-ins over editing packaged unit files.
- Preserve ownership, permissions, ACLs, mount options, and labels.

## Validation

- Service starts now and after reboot.
- Logs show no new errors.
- Expected ports listen and unexpected ports do not.
- SSH access still works.
- SELinux and firewall state match the intended policy.
