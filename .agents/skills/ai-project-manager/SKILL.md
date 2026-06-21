---
name: ai-project-manager
description: Turn repository planning docs into actionable AI-agent implementation plans using AGENTS.md, SPEC.md, ROADMAP.md, TASKS.md, validation, and incremental execution. Use when Codex is asked to plan a project, derive tasks from docs, coordinate phases, update task status, or manage an AI-assisted development workflow.
---

# ai-project-manager

## Workflow

1. Gather repository instructions and planning docs.
2. Determine conflicts, missing requirements, and implementation impact.
3. Create a phase plan with rollback or pause points.
4. Execute one small phase at a time.
5. Validate, summarize, and update task status.

## Diagnostics

```bash
sed -n '1,220p' AGENTS.md
sed -n '1,220p' docs/SPEC.md
sed -n '1,220p' docs/ROADMAP.md
sed -n '1,220p' docs/TASKS.md
rg --files
git status --short
```

## Safety Rules

- Never rewrite project requirements unless asked.
- Never mark a task done without validation or a stated reason validation was skipped.
- Never ignore conflicts between SPEC, ROADMAP, TASKS, and code.
- Keep project-specific knowledge in project docs, not reusable skills.
- Prefer small reviewable phases over broad plans.

## Validation

- Plan maps to documented requirements.
- Each task has clear scope and acceptance criteria.
- Validation commands are defined before implementation.
- Completed work updates task status when appropriate.
- Final summary lists changed files, checks run, skipped checks, and residual risk.
