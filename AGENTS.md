# Repository instructions

## Scope

This repository is the source of truth for Titus's portable Codex
configuration and reusable skills.

## Command execution

- Prefix shell commands with `rtk` when `rtk` is installed.
- If `rtk` is unavailable, state that once and use the raw command.
- In command chains, apply `rtk` to each supported command segment.
- If `rtk` rejects an unsupported command or flag, retry it raw.
- Use raw commands when debugging command filtering.

## Editing

- Use simple ASCII punctuation unless a file format requires otherwise.
- Keep credentials, tokens, sessions, history, caches, logs, and runtime
  databases out of this repository.
- Put reusable workflows in `.agents/skills/<name>/SKILL.md`.
- Put portable user configuration in `codex-home/`.
- Put project maintenance instructions in this file.
- Do not assume files in `docs/` are loaded automatically.

## Documentation routing

Read only the documents needed for the task:

- `docs/CODEX_LAYOUT.md` for Codex discovery and installation boundaries.
- `docs/SKILLS.md` when creating or changing skills.
- `docs/WORKFLOW.md` when changing the repository development workflow.

## Validation

Run `./scripts/validate.sh` after changing configuration, skills, install
scripts, or repository layout.
