# Narehood AI specification

## Problem

Coding-agent installations mix portable configuration with credentials, sessions,
caches, and other machine-local state. Teams need a public, reusable baseline for
T3 Code (and the providers it can run) without replacing project-specific
requirements or leaking private product operations.

## Users

The primary user is a developer who works across Linux, macOS, and Windows and
wants the same safe agent baseline in multiple repositories, with T3 Code as
the control surface.

## Public repository

This repository is public. Tracked files must stay world-readable and free of:

- credentials, sessions, caches, logs, and runtime databases
- T3 Code userdata, pairing URLs, or pairing tokens
- personal absolute home paths or private project lists
- private product deploy hosts, app IDs, entitlement IDs, or secret values
- operational inventories that reveal private infrastructure

Examples and templates use placeholders only.

## Required behavior

- Provide durable project instruction conventions (`AGENTS.md`) and reusable
  skills under `.agents/skills/` that T3 Code and its providers can discover.
- Document T3 Code project-root, `$` picker, and public-repo boundaries without
  mirroring a live `~/.t3` home.
- Document Cursor and Codex discovery as provider adapters, not as competing
  sources of truth.
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
- Use the built-in `codex review --uncommitted` workflow for local review when
  Codex is available, with validation and review repeated after each actionable
  fix.
- Validate repository structure, configuration syntax, skill metadata,
  documentation consistency, and installer behavior.
- Run Linux, macOS, and Windows validation for pull requests and default-branch
  pushes.

## Architecture

- `.agents/skills/` is the canonical Agent Skills tree. T3 Code's `$` picker
  and provider scanners read it from the project root; the installer links it
  into `AGENTS_HOME` for user scope.
- `codex-home/` contains portable Codex files installed into `CODEX_HOME` when
  the Codex provider is used.
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
- `docs/T3CODE_LAYOUT.md`, `docs/CURSOR_LAYOUT.md`, and `docs/CODEX_LAYOUT.md`
  document discovery boundaries for the control surface and each adapter.

## Security and privacy

- Never track authentication files, session history, caches, logs, runtime
  databases, or T3 Code userdata.
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

- Mirroring the complete Codex, Cursor, Claude, or T3 Code home directory.
- Managing credentials, plugin caches or authentication, sessions, or caches.
- Installing plugins without an explicit opt-in.
- Replacing project-specific `AGENTS.md` or requirements.
- Installing T3 Code, Cursor, Codex, Claude Code, third-party review CLIs, RTK,
  or local model servers.
- Duplicating skills into `.claude/skills/` or `.cursor/skills/`.
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

- Whether a committed public-safe `t3.json` (icon only, no local paths) should
  be added later; for now, T3 Code project settings stay machine-local.
- Whether T3 Code's Claude `$` picker will always include repo-local
  `.agents/skills`; skills stay invocable by name regardless.
