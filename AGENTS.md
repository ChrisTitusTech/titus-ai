# Repository instructions

## Scope

This repository is the source of truth for Narehood's portable coding-agent
configuration, reusable skills, and durable instructions. T3 Code is the
control surface. Codex, Claude Code, and Cursor are first-class providers it
can run; skills and `AGENTS.md` must work in all three, in T3 Code or in each
provider's own CLI. The root `AGENTS.md` is the project maintenance file and
follows the AGENTS.md convention for tools that load it automatically.

This repository is public. Do not commit credentials, personal absolute paths,
private product operations, secret values, T3 Code userdata, or pairing tokens.

## Operating principles

- Working code only. Plausibility is not correctness; verify before reporting
  done.
- Never fabricate file paths, APIs, commit hashes, command output, or test
  results. Read the file, run the command, or say what is unknown.
- Say when a premise appears wrong before implementing around it.
- Ask before proceeding only when a request has multiple plausible
  interpretations and the choice materially affects the result.
- Touch only what the task requires. Avoid drive-by refactors, formatting, or
  cleanup.
- Keep communication direct and concise. Skip flattery, filler, ceremonial
  openings, and emoji.

## Pull requests

Unless the user explicitly says not to, or the change cannot produce a
reviewable result:

1. Work on a feature branch (not the default branch directly).
2. Keep the branch synced with the base branch and resolve merge conflicts
   before asking for review.
3. Open or update a pull request after pushing meaningful work.
4. If the host reports merge conflicts on the PR, fix them on the branch and
   push again until the PR is mergeable.

## Blocked by keys or auth

If a task is blocked by a missing secret, API key, login, 2FA, or dashboard
permission on the human's side:

1. Stop. Do not invent workarounds that ship a degraded product.
2. Ask clearly for the exact credential or action needed.
3. Wait for the human before continuing expensive work (paid builds, store
   submits, production deploys).

## Command execution

- Prefer running code, tests, linters, and type checks over guessing.
- Read complete errors, logs, and stack traces before fixing them.

## Before editing

- State the plan or success criteria before editing. For non-trivial work,
  include the verification you expect to run.
- Read the files you will touch and the nearby callers, consumers, or docs that
  define their behavior.
- Match existing project patterns, naming, layout, and style even if a different
  approach would be appealing in a new project.
- Resolve ambiguity by reading code or running commands when practical; surface
  assumptions out loud when they affect the result.

## Editing

- Keep credentials, tokens, sessions, history, caches, logs, and runtime
  databases out of this repository.
- Put reusable workflows in `.agents/skills/<name>/SKILL.md` so Codex, Claude,
  and Cursor can all load them (Agent Skills standard; T3 Code `$` picker).
- Put portable Codex user configuration in `codex-home/`.
- Keep `CLAUDE.md` as a thin router to this file.
- Put project maintenance instructions in this file.
- Do not assume files in `docs/` are loaded automatically.
- Use the minimum code or documentation change that solves the stated problem.
- Do not add speculative features, abstractions, configurability, or hooks.
- Do clean up orphans created by your own change, such as unused imports or
  obsolete helper functions.
- Do not delete pre-existing dead code unless asked; mention it in the summary
  if it matters.

## Documentation routing

Read only the documents needed for the task:

- `SPEC.md` for product requirements, boundaries, and acceptance criteria.
- `ROADMAP.md` for ordered outcomes, risks, and phase exit criteria.
- `TASKS.md` for the current phase, validation status, and remaining work.
- `docs/T3CODE_LAYOUT.md` for T3 Code project, skill, and public-repo
  boundaries.
- `docs/CODEX_LAYOUT.md` for Codex discovery and installation boundaries.
- `docs/CLAUDE_LAYOUT.md` for Claude Code discovery boundaries.
- `docs/CURSOR_LAYOUT.md` for Cursor and Cloud Agent discovery boundaries.
- `docs/SKILLS.md` when creating or changing skills.
- `docs/WORKFLOW.md` when changing the repository development workflow.

## Verification

- Run the smallest meaningful verification during iteration and the requested or
  relevant final verification before reporting done.
- If verification fails, fix the cause instead of weakening the check.
- For UI or visual changes, verify visually with screenshots or equivalent
  rendered output.
- Run `./scripts/validate.sh` after changing configuration, skills, install
  scripts, or repository layout.
- Run `./scripts/test-install.sh` directly when diagnosing Linux or macOS
  installer behavior. Windows installer behavior is covered by
  `./scripts/test-install.ps1` in CI.
- After the complete local gate passes for a non-trivial change, run
  `codex review --uncommitted`. Verify every finding against the current diff,
  fix only actionable defects, rerun affected validation, and repeat the review
  until no actionable findings remain.
- When the active task is itself a code review, inspect the changes and report
  findings directly. Never invoke a nested `codex review` from review mode.
- Treat an unavailable or failed Codex review as an explicit readiness blocker.
  Do not silently substitute a third-party review CLI.

## Maintenance

- Keep this file short enough to follow. Add rules only when they prevent a real
  repeat mistake or document durable project behavior.
- Route corrections to the narrowest durable scope: cross-repository behavior
  belongs in `codex-home/AGENTS.md`, reusable workflows belong in a skill, and
  project-specific behavior belongs in that project's `AGENTS.md` or
  specification. Do not duplicate the same rule across scopes.
- When the user corrects an approach, tighten the relevant rule instead of
  appending a vague warning.
