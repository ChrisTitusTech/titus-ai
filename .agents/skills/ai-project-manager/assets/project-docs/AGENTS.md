# Project instructions

## Purpose

Describe the project, its users, and the outcome it provides.

## Architecture

- List the important directories and components.
- Identify generated files and external interfaces.
- Document the supported toolchain and target environments.

## Working boundaries

- Preserve unrelated changes.
- Do not expose or commit credentials, sessions, private data, or environment
  files.
- Ask before destructive operations, migrations, deployments, or changes that
  require a product or architecture decision.

## Commands

Document the exact setup, formatting, lint, type-check, test, build, and run
commands used by this repository.

## Validation

- Run focused checks while implementing.
- Run the complete required local gate before reporting done.
- Inspect the final status and diff.
- Verify visible behavior with screenshots or equivalent rendered evidence.
- Report skipped checks and unresolved manual testing explicitly.

## Documentation routing

- Read `SPEC.md` for requirements and acceptance criteria.
- Read `ROADMAP.md` for phase order and exit criteria.
- Read `TASKS.md` for current work and validation status.
