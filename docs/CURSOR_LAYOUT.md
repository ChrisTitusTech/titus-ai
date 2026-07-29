# Cursor configuration layout

## What Cursor loads automatically

Cursor and Cloud Agents discover a limited set of instruction and skill paths:

| Purpose | User scope | Repository scope |
| --- | --- | --- |
| Instructions | Cursor User Rules (UI) | Root and nested `AGENTS.md` |
| Scoped rules | Team Rules (dashboard) | `.cursor/rules/*.mdc` (versioned) |
| Skills | `~/.agents/skills/`, `~/.cursor/skills/` | `.agents/skills/`, `.cursor/skills/` |

Cursor does not recursively treat arbitrary files under `docs/` as
instructions. A loaded `AGENTS.md`, selected skill, or user prompt must point
the agent to the relevant document.

Optional: root `CLAUDE.md` may be read by Cursor CLI alongside `AGENTS.md`. This
repository keeps `CLAUDE.md` as a thin router plus RTK notes.

## Why this repository is not a full Cursor home mirror

A user Cursor install mixes portable guidance with private and ephemeral state
(accounts, chat history, local settings, secrets). This public repository
manages only:

- durable project instruction conventions
- reusable skills under `.agents/skills/`
- planning and workflow documentation
- optional Codex portable home files (secondary)

Do not commit personal absolute paths, private product operations, or secret
values.

## Skills

Canonical skills live in `.agents/skills/<name>/SKILL.md`. Cursor discovers that
path in the repository. The installer links the same tree into
`~/.agents/skills/` so skills are available in other projects.

Prefer `.agents/skills/` as the portable source of truth. Add
`.cursor/skills/` only when a Cursor-only skill must not be shared with Codex.
Do not duplicate skill bodies into both trees.

## Project rules vs AGENTS.md

- Use root `AGENTS.md` for durable repository conventions that every agent
  should load.
- Use `.cursor/rules/*.mdc` when you need Cursor-specific `alwaysApply`,
  `description`, or `globs` scoping that plain `AGENTS.md` cannot express.
- Keep team-wide policy in Team Rules when available; project files remain the
  portable baseline for public and cloned repos.

## Cloud Agents

Cloud Agents also read project `AGENTS.md`. Optional Cloud boot configuration
may live in `.cursor/environment.json` (install/start commands, ports). Secrets
belong in the Cursor dashboard Secrets store, never in committed JSON.

This public starter does not require a committed `environment.json`; add one in
downstream projects when shared Cloud boot is useful.

## Relationship to Codex

Codex discovery and install boundaries are documented in
[CODEX_LAYOUT.md](CODEX_LAYOUT.md). Shared skills and planning templates serve
both surfaces. Cursor is the primary target for Narehood AI.
