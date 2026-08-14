# T3 Code layout

T3 Code is the control surface for this repository: a GUI that runs provider
CLIs against a project directory. The providers this repo is built to support
are **Codex**, **Claude Code**, and **Cursor**. T3 Code may also run Grok or
OpenCode; those sessions still load the shared files below.

Portable instructions and skills must work for every supported provider, in T3
Code or in that provider's own CLI. Do not depend on one provider's private
home directory.

## Shared files every provider should see

| Purpose | Path | Codex | Claude | Cursor |
| --- | --- | --- | --- | --- |
| Project instructions | Root `AGENTS.md` | yes | yes (via `CLAUDE.md`) | yes |
| Claude router | Root `CLAUDE.md` | no | yes | optional |
| Skills | `.agents/skills/<name>/SKILL.md` | yes | yes | yes |
| User-global skills | `~/.agents/skills/` after install | yes | yes | yes |
| Codex home | `codex-home/` via the installer | yes | no | no |

T3 Code's composer `$` picker lists repo-local `.agents/skills` when the thread
cwd is the repository root. Invoke a skill with `$` plus the skill name:

```text
$ai-project-manager draft the next phase
$linux-sysadmin diagnose this service failure
```

Providers may also auto-select a skill from its `description`. Keep those
descriptions provider-agnostic so Codex, Claude, and Cursor can all match them.

T3 Code does not recursively treat `docs/` as instructions. Point the agent at
a document from `AGENTS.md`, a selected skill, or the prompt.

## Open this project correctly

Add this repository as a T3 Code project rooted at the Git checkout, not a
parent folder and not a nested subdirectory. Skill discovery is cwd-scoped.

## Canonical skill location

Use the [Agent Skills](https://agentskills.io) directory:

```text
.agents/skills/<skill-name>/SKILL.md
```

Do not duplicate skill bodies into `.claude/skills/` or `.cursor/skills/`.
Those trees are only for a skill that must not be shared. If a T3 Code Claude
picker omits a repo-local `.agents` skill, the skill remains invocable by
`$name`; fix discovery rather than copying files.

The installer links `.agents/skills/` into `~/.agents/skills/` so the same
skills are available in other projects, including ones opened outside T3 Code.

## Provider-specific layout

- Codex: [CODEX_LAYOUT.md](CODEX_LAYOUT.md) (`codex-home/`, trust, plugins)
- Claude Code: [CLAUDE_LAYOUT.md](CLAUDE_LAYOUT.md) (`CLAUDE.md` router)
- Cursor: [CURSOR_LAYOUT.md](CURSOR_LAYOUT.md) (`AGENTS.md`, optional rules)

## Public repository boundaries

This repository is public. Do not commit:

- T3 Code userdata, SQLite state, or worktree `.t3/` directories
- pairing URLs or tokens
- provider credentials, sessions, caches, or plugin state
- personal absolute home paths or private project lists

Reading a local `~/.t3/userdata` copy for debugging is fine. Never point a
dev server at the live T3 Code home, and never check that home into git.

## Verification

After opening the project in T3 Code, pick Codex, Claude, or Cursor and ask:

```text
List the instruction sources and skills active for this repository.
```

Expected sources include root `AGENTS.md` and the skills under
`.agents/skills/`. Claude sessions should also show `CLAUDE.md`. User-global
skill copies appear only after install.
