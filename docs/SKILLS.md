# Skills for coding agents

## Purpose

A skill is a reusable workflow with focused instructions, optional references,
and optional scripts.

Use a skill for knowledge that is:

- reused across repositories
- independent of one project's requirements
- specific enough to have a reliable trigger
- too detailed for global or repository instructions

## Discovery locations

Canonical portable location (Agent Skills standard, T3 Code `$` picker):

```text
repository/.agents/skills/<skill-name>/SKILL.md
~/.agents/skills/<skill-name>/SKILL.md
```

T3 Code surfaces repo-local skills when the thread cwd is the repository root
and the provider is Codex, Claude, or Cursor. The installer links this tree
into the user location so skills are available in other projects. See
[T3CODE_LAYOUT.md](T3CODE_LAYOUT.md).

Codex, Claude Code, and Cursor all load `.agents/skills/`. Cursor also
discovers `.cursor/skills/`. Claude Code also discovers `.claude/skills/`.
Prefer `.agents/skills/` as the source of truth so skills stay shared. Do not
duplicate skill bodies into provider-only trees.

## Required layout

```text
.agents/skills/skill-name/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
└── scripts/
```

Only `SKILL.md` is required. It must start with YAML front matter containing a
clear `name` and `description`.

## Authoring rules

- Keep each skill focused on one workflow.
- Put trigger terms and boundaries in the description.
- Write imperative steps with explicit inputs, outputs, and validation.
- Load references only when the task needs them.
- Prefer instructions over scripts unless deterministic automation is useful.
- Keep project requirements in project documentation, not reusable skills.
- Use `agents/openai.yaml` only for useful UI metadata or dependencies.
- Prefer agent-agnostic trigger wording ("coding agent", not a provider name).

## Repository skills

- `ai-project-manager`
- `bash-scripting`
- `forgejo-maintainer`
- `homelab-admin`
- `hugo`
- `linux-sysadmin`
- `mdbook`
- `podman-operator`
- `pr-readiness`
- `python-ai`
- `quickshell`
- `rust-cli`
- `youtube-thumbnail`

Run `./scripts/validate.sh` after adding or changing a skill. Validation fails
when this list and the skill directories drift apart.
