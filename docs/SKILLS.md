# Skills for Codex

## Purpose

A skill is a reusable workflow with focused instructions, optional references,
and optional scripts.

Use a skill for knowledge that is:

- reused across repositories
- independent of one project's requirements
- specific enough to have a reliable trigger
- too detailed for global or repository instructions

## Discovery locations

Use the current documented locations:

```text
repository/.agents/skills/<skill-name>/SKILL.md
~/.agents/skills/<skill-name>/SKILL.md
```

Codex scans repository skill directories from the working directory up to the
repository root. The installer links this repository's skills into the user
location so they are available in other repositories.

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
- Keep diagnostic examples conditional on the task, platform, and deployment
  mode. Do not print credentials or imply authorization for external writes.
- Preserve domain invariants, but remove duplicated process rules and
  unnecessary approval pauses. User instructions govern skill guidelines.
- Audit descriptions for accidental activation and references for conflicting
  rules. Reuse unchanged validation evidence instead of stacking review loops.

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
- `wayfinder`
- `youtube-thumbnail`

Run `./scripts/validate.sh` after adding or changing a skill. Validation fails
when this list and the skill directories drift apart.
