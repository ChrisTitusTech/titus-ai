---
name: linux-sysadmin
description: Diagnose and operate Linux hosts, services, packages, permissions, SELinux, firewalls, and SSH. Use for host-level work that is not primarily an application-specific or container task.
---

# linux-sysadmin

## Workflow

1. Gather diagnostics for the reported symptom and complete relevant log
   interval. Do not run every example below for an isolated service issue.
2. Determine whether the failure is host-level or primarily belongs to a
   specialized application, container, or cross-system infrastructure skill.
3. For an authorized fix, identify impact and recent changes, then prepare
   rollback for the files, packages, units, or firewall rules being changed.
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

- The affected service runs and its boot configuration is correct. Reboot only
  when authorized; distinguish inspection from a verified reboot test.
- Logs show no new errors.
- Expected ports listen and unexpected ports do not.
- SSH access still works.
- SELinux and firewall state match the intended policy.
