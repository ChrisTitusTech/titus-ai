# Narehood AI tasks

## Completed phase: Workflow alignment

- [x] Add project planning documents and reusable planning templates.
- [x] Add a focused pull-request readiness skill.
- [x] Add isolated Linux, macOS, and Windows installer integration tests.
- [x] Add pull-request CI, dependency review, Dependabot, and a PR template.
- [x] Align Claude routing and workflow documentation.
- [x] Replace the third-party local review loop with built-in Codex review.
- [x] Add opt-in, cross-platform installation for selected Codex plugins.
- [x] Trust all Git worktrees beneath the current user's `~/github` directory.
- [x] Run local repository, shell, installer, workflow, and skill validation.
- [x] Confirm Windows installer integration, including plugin installation and
  recursive GitHub trust generation, passes in CI.
- [x] Inspect the final diff and stage only workflow-alignment changes.

## Completed phase: Cursor-first + Narehood rebrand

- [x] Reframe SPEC, ROADMAP, TASKS, README, and root AGENTS for Cursor-primary
  Narehood AI (public-safe).
- [x] Complete Narehood AI / narehood-ai rebrand; strip personal absolute paths
  from sample config and skill examples.
- [x] Expand project-docs AGENTS template; add STATUS.md template; update
  ai-project-manager skill.
- [x] Add CURSOR_LAYOUT.md; update SKILLS and WORKFLOW; soften Codex-only skill
  wording; align global instructions.
- [x] Document Cursor skills consumption; extend validate if needed; run
  validate.sh; public-repo leak-check.

## Completed phase: T3 Code control surface

- [x] Document T3 Code as the control surface (`docs/T3CODE_LAYOUT.md`).
- [x] Retarget README, SPEC, AGENTS, SKILLS, and WORKFLOW for T3 Code while
  keeping the repo public-safe.
- [x] Keep `.agents/skills/` canonical; ignore local `.t3/` userdata.
- [x] Document Codex, Claude Code, and Cursor as first-class T3 Code providers
  (`docs/CODEX_LAYOUT.md`, `docs/CLAUDE_LAYOUT.md`, `docs/CURSOR_LAYOUT.md`).
- [x] Run `./scripts/validate.sh` after the retarget.

## Current phase: Enforced repository governance

- [ ] Configure a default-branch ruleset after CI check names exist remotely.
- [ ] Require pull requests, successful validation, and conversation resolution.
- [ ] Require an independent approval when repository ownership permits it.

## Completion rule

Move current-phase tasks to completed only after their acceptance criteria and
required validation pass. Keep external GitHub settings pending until verified
through the live repository.
