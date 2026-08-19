---
name: ai-project-manager
description: Create and maintain repository planning documents, phased implementation plans, approval checkpoints, task status, and validation evidence for AI-assisted development work.
---

# ai-project-manager

## Workflow

1. Inspect repository instructions, current changes, and the active branch.
2. Identify which planning documents are relevant to the task. Locate each
   relevant `SPEC.md`, `ROADMAP.md`, or `TASKS.md` at the repository root first,
   then under `docs/`. If both locations contain a relevant document, read both
   and surface conflicts.
3. Determine missing requirements, unresolved decisions, dependencies, risks,
   and implementation impact.
4. Create a phase plan that maps to acceptance criteria and defines automated
   validation, manual validation, rollback, and pause points.
5. Present the plan and stop when the user requested planning only or reserved
   implementation approval.
6. Once implementation is authorized, execute one reviewable phase at a time.
7. Validate the phase, inspect the diff, summarize evidence, and update task
   status only after the exit criteria pass.
8. Hand completed implementation to a pull-request readiness workflow when the
   user asks to prepare, review, publish, or merge the change.

## Diagnostics

```bash
git status --short
git branch --show-current
rg --files -g 'AGENTS.md' -g 'AGENTS.override.md' -g 'SPEC.md' -g 'ROADMAP.md' -g 'TASKS.md'
```

Read every applicable `AGENTS.md` and each planning document relevant to the
task. Do not assume that planning files live under `docs/`.

If the user asks to create missing planning files, adapt the templates under
`assets/project-docs/` to the repository. Remove irrelevant sections instead of
leaving placeholders or inventing requirements.

## Safety Rules

- Never rewrite project requirements unless asked.
- Never mark a task done without validation or a stated reason validation was skipped.
- Never ignore conflicts between SPEC, ROADMAP, TASKS, and code.
- Never cross a user approval or plan-only checkpoint.
- Never treat an agent's implementation report as validation evidence.
- Keep project-specific knowledge in project docs, not reusable skills.
- Prefer small reviewable phases over broad plans.

## Validation

- Plan maps to documented requirements.
- Each task has clear scope and acceptance criteria.
- Automated and manual validation are defined before implementation.
- Completed work updates task status when appropriate.
- The final diff contains only the intended phase.
- Final summary lists changed files, checks run, skipped checks, and residual risk.
