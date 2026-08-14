# Claude Code configuration layout

## What Claude Code loads automatically

Claude Code (including when T3 Code selects the Claude provider) discovers a
limited set of instruction and skill paths:

| Purpose | User scope | Repository scope |
| --- | --- | --- |
| Instructions | `~/.claude/CLAUDE.md` | Root `CLAUDE.md`, then `AGENTS.md` |
| Skills | `~/.agents/skills/`, `~/.claude/skills/` | `.agents/skills/`, `.claude/skills/` |

Claude Code does not recursively treat arbitrary files under `docs/` as
instructions. This repository's root `CLAUDE.md` is a thin router: read
`AGENTS.md` first, then follow its documentation routing.

## Why this repository is not a full Claude home mirror

A user Claude install mixes portable guidance with private and ephemeral state
(accounts, transcripts, local settings, secrets, plugin caches). This public
repository manages only:

- the root `CLAUDE.md` router
- durable project instruction conventions in `AGENTS.md`
- reusable skills under `.agents/skills/`

Do not commit personal absolute paths, private product operations, or secret
values. Do not add a second copy of each skill under `.claude/skills/`.

## Skills

Canonical skills live in `.agents/skills/<name>/SKILL.md`. Claude Code loads
that Agent Skills directory. The installer links the same tree into
`~/.agents/skills/` so skills are available in other projects.

Add `.claude/skills/` only when a Claude-only skill must not be shared with
Codex or Cursor. Do not duplicate skill bodies into both trees.

In T3 Code, type `$` in the composer to pick a skill. If the Claude picker
omits a repo-local `.agents` skill, invoke it by `$name` anyway.

## Relationship to T3 Code, Codex, and Cursor

T3 Code is the control surface and can run Claude, Codex, or Cursor against
this checkout. Shared skills and `AGENTS.md` serve all three. See
[T3CODE_LAYOUT.md](T3CODE_LAYOUT.md), [CODEX_LAYOUT.md](CODEX_LAYOUT.md), and
[CURSOR_LAYOUT.md](CURSOR_LAYOUT.md).
