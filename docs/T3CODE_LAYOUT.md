# T3 Code layout

T3 Code is the intended control surface for this repository. It is a GUI that
runs provider CLIs (Codex, Claude Code, Cursor, Grok, and OpenCode) against a
project directory. Portable instructions and skills in this repo must work
through T3 Code without depending on one provider's private home directory.

## What T3 Code uses from this repository

| Purpose | Path | Who loads it |
| --- | --- | --- |
| Project instructions | Root `AGENTS.md` | The active provider (Codex, Cursor, Claude, and others) |
| Claude router | Root `CLAUDE.md` | Claude Code when it is the selected provider |
| Skills | `.agents/skills/<name>/SKILL.md` | T3 Code `$` picker plus each provider's skill scanner |
| User-global skills | `~/.agents/skills/` after install | Other projects opened in T3 Code |
| Codex home | `codex-home/` via the installer | Codex provider only |

T3 Code does not recursively treat `docs/` as instructions. Point the agent at
a document from `AGENTS.md`, a selected skill, or the prompt.

## Open this project correctly

Add this repository as a T3 Code project rooted at the Git checkout, not a
parent folder and not a nested subdirectory. Skill discovery is cwd-scoped:
threads whose working directory is the repo root see `.agents/skills/`.

Invoke a skill from the composer with `$` plus the skill name:

```text
$ai-project-manager draft the next phase
$linux-sysadmin diagnose this service failure
```

Providers may also auto-select a skill from its `description`. Keep those
descriptions provider-agnostic.

## Canonical skill location

Use the [Agent Skills](https://agentskills.io) directory:

```text
.agents/skills/<skill-name>/SKILL.md
```

Do not duplicate skill bodies into `.claude/skills/` or `.cursor/skills/`.
Provider-specific trees are adapters for skills that must not be shared. If a
T3 Code Claude picker omits a repo-local `.agents` skill, the skill remains
invocable by `$name`; fix discovery in T3 Code rather than copying files.

The installer links `.agents/skills/` into `~/.agents/skills/` so the same
skills are available in other T3 Code projects.

## Public repository boundaries

This repository is public. Do not commit:

- T3 Code userdata, SQLite state, or worktree `.t3/` directories
- pairing URLs or tokens
- provider credentials, sessions, caches, or plugin state
- personal absolute home paths or private project lists

Reading a local `~/.t3/userdata` copy for debugging is fine. Never point a
dev server at the live T3 Code home, and never check that home into git.

## Provider adapters

- Codex: optional `codex-home/` install. See [CODEX_LAYOUT.md](CODEX_LAYOUT.md).
- Cursor: project `AGENTS.md` plus `.agents/skills/`. See
  [CURSOR_LAYOUT.md](CURSOR_LAYOUT.md).
- Claude: root `CLAUDE.md` routes to `AGENTS.md`. Do not add a second skill
  tree unless a Claude-only workflow cannot live under `.agents/skills/`.

## Verification

After opening the project in T3 Code, ask:

```text
List the instruction sources and skills active for this repository.
```

Expected sources include root `AGENTS.md` and the skills under
`.agents/skills/`. User-global copies appear only after install.
