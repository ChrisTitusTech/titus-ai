# Titus AI specification

## Problem

Codex installations mix portable configuration with credentials, sessions,
caches, and other machine-local state. Coding agents also need consistent
instructions and reusable workflows without replacing project-specific
requirements.

## Users

The primary user is a developer who works across Linux, macOS, and Windows and
wants the same safe Codex baseline in multiple repositories.

## Required behavior

- Install global Codex instructions, configuration, rules, local-model
  profiles, and reusable skills from this repository.
- Preview installation without changing the target system.
- Preserve existing managed targets in timestamped backups before replacement.
- Leave credentials, sessions, history, caches, plugins, and runtime databases
  untouched.
- Support repeated installation without replacing already-correct links.
- Provide project-planning templates and separate planning from pull-request
  readiness.
- Validate repository structure, configuration syntax, skill metadata,
  documentation consistency, and installer behavior.
- Run Linux, macOS, and Windows validation for pull requests and default-branch
  pushes.

## Architecture

- `codex-home/` contains portable files linked into `CODEX_HOME`.
- `.agents/skills/` contains reusable workflows linked into `AGENTS_HOME`.
- `scripts/install.sh` and `scripts/install.ps1` perform user-scoped
  installation.
- `scripts/validate.sh` and installer integration tests provide local and CI
  evidence.
- `AGENTS.md`, this specification, `ROADMAP.md`, and `TASKS.md` define how the
  repository is maintained.

## Security and privacy

- Never track authentication files, session history, caches, logs, or runtime
  databases.
- Do not require administrator privileges for normal installation.
- Keep destructive actions narrowly scoped and require explicit authorization.
- Give GitHub Actions the minimum permissions required by each job.
- Pin third-party actions and let Dependabot keep those pins current.

## Compatibility

- The shell installer targets Bash on Linux and macOS.
- The PowerShell installer targets supported Windows PowerShell environments
  capable of creating symbolic links.
- Optional tools may add validation but must not make ordinary installation
  depend on unrelated developer tooling.

## Non-goals

- Mirroring the complete Codex home directory.
- Managing credentials, plugins, sessions, or caches.
- Replacing project-specific `AGENTS.md` or requirements.
- Installing Codex, Claude Code, CodeRabbit, RTK, or local model servers.
- Adding security scanners that do not support the repository's languages.

## Acceptance criteria

- `./scripts/validate.sh` passes from a clean checkout.
- Linux and macOS installer integration tests verify dry-run safety, backup
  preservation, correct links, and idempotence in isolated temporary
  directories.
- Windows CI verifies the equivalent PowerShell installer behavior.
- Every skill has valid front matter and the documented skill inventory matches
  the actual directories.
- Pull requests run validation and dependency review on the latest commit.
- Workflow documentation covers planning, implementation, review, manual
  testing, and merge gates.

## Unresolved questions

- Whether future installers should offer optional user-wide Claude Code
  instructions in addition to the repository-local `CLAUDE.md` routing.
