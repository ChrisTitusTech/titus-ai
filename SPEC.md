# Narehood AI specification

## Problem

Coding-agent installations mix portable configuration with credentials, sessions,
caches, and other machine-local state. Teams need a public, reusable baseline for
Cursor (and optional Codex) instructions and skills without replacing
project-specific requirements or leaking private product operations.

## Users

The primary user is a developer who works across Linux, macOS, and Windows and
wants the same safe agent baseline in multiple repositories, with Cursor as the
primary surface.

## Public repository

This repository is public. Tracked files must stay world-readable and free of:

- credentials, sessions, caches, logs, and runtime databases
- personal absolute home paths or private project lists
- private product deploy hosts, app IDs, entitlement IDs, or secret values
- operational inventories that reveal private infrastructure

Examples and templates use placeholders only.

## Required behavior

- Provide durable project instruction conventions (`AGENTS.md`) and reusable
  skills under `.agents/skills/` that Cursor and Codex can discover.
- Document Cursor discovery paths, optional `.cursor/rules`, and Cloud Agent
  environment notes without mirroring a full user Cursor home.
- Optionally install global Codex instructions, configuration, rules,
  local-model profiles, and skills from this repository.
- Optionally install an explicit list of recommended Codex plugins from
  configured marketplaces.
- Trust the current user's `~/github` directory and every Git worktree
  discovered recursively beneath it on each Codex installation.
- Preview installation without changing the target system.
- Preserve existing managed targets in timestamped backups before replacement.
- Leave credentials, sessions, history, caches, plugin state, and runtime
  databases untouched unless plugin installation is explicitly requested.
- Support repeated installation without replacing already-correct links.
- Provide project-planning templates (including optional `STATUS.md`) and
  separate planning from pull-request readiness.
- Use the built-in `codex review --uncommitted` workflow for local review, with
  validation and review repeated after each actionable fix.
- Validate repository structure, configuration syntax, skill metadata,
  documentation consistency, and installer behavior.
- Run Linux, macOS, and Windows validation for pull requests and default-branch
  pushes.

## Architecture

- `.agents/skills/` contains reusable workflows discovered by Cursor and linked
  into `AGENTS_HOME` for user scope.
- `codex-home/` contains portable Codex files installed into `CODEX_HOME`
  (secondary to Cursor).
- The Codex installer renders `config.toml` with machine-specific exact trust
  entries while linking the other managed files. The committed sample config
  must not contain personal absolute paths.
- `scripts/install.sh` and `scripts/install.ps1` perform user-scoped Codex
  installation and skill linking.
- `codex-plugins.txt` records plugin selectors installed only through the
  explicit plugin option.
- `scripts/validate.sh` and installer integration tests provide local and CI
  evidence.
- `AGENTS.md`, this specification, `ROADMAP.md`, and `TASKS.md` define how the
  repository is maintained.
- `docs/CURSOR_LAYOUT.md` and `docs/CODEX_LAYOUT.md` document discovery
  boundaries for each agent surface.

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

- Mirroring the complete Codex or Cursor home directory.
- Managing credentials, plugin caches or authentication, sessions, or caches.
- Installing plugins without an explicit opt-in.
- Replacing project-specific `AGENTS.md` or requirements.
- Installing Cursor, Codex, Claude Code, T3 Code, third-party review CLIs, RTK,
  or local model servers.
- Shipping private product operations or identity-leaking sample config.
- Adding security scanners that do not support the repository's languages.

## Acceptance criteria

- `./scripts/validate.sh` passes from a clean checkout.
- Linux and macOS installer integration tests verify dry-run safety, backup
  preservation, machine-local configuration state, correct links, generated
  GitHub trust entries, and idempotence in isolated temporary directories.
- Windows CI verifies the equivalent PowerShell installer behavior.
- Installer tests verify plugin opt-in and dry-run behavior without contacting
  a live marketplace.
- Every skill has valid front matter and the documented skill inventory matches
  the actual directories.
- The pull-request readiness workflow requires a clean Codex review loop and
  does not depend on a third-party review service.
- Committed configuration and docs contain no personal absolute home paths.
- Pull requests run validation and dependency review on the latest commit.
- Workflow documentation covers planning, implementation, review, manual
  testing, and merge gates.

## Unresolved questions

- Whether a dedicated Cursor user-rules exporter or team-rules sync should be
  added later; for now, project `AGENTS.md` and linked skills are the portable
  surface.
