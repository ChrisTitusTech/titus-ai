# Global Codex instructions

## Command execution

- Use `rtk` when command output is likely to be large or repetitive and a
  filtered summary is sufficient. Good candidates include test suites, builds,
  linters, logs, broad searches, dependency listings, and infrastructure
  status commands.
- Use raw commands when output is expected to be short, when exact or complete
  output matters, or when inspecting a specific file or narrowly scoped result.
- In command chains, apply `rtk` only to segments that benefit from filtering.
- If RTK hides needed detail, rejects a command or flag, or complicates
  debugging, rerun the command raw. Do not use `rtk proxy` merely to satisfy an
  RTK convention.
- If a task is primarily Bash or command-line automation, consider RTK for
  noisy validation commands, but keep commands raw when validating exact
  stdout, stderr, exit-status, quoting, or pipeline behavior.
- When a task requires multiple SSH commands to the same remote host, use
  persistent client multiplexing when possible: establish one authenticated
  master with `ControlMaster`, `ControlPath`, and `ControlPersist`, verify it,
  and reuse its channels for every sequential or concurrent command. Close a
  task-scoped master when the remote work is complete.
- If required multiplexed concurrency exceeds the server's authenticated
  channel limit, confirm the limit before changing it. Raise `MaxSessions` only
  with rollback and validation, and do not weaken unauthenticated connection
  limits or per-source abuse penalties to improve command throughput.

## Working style

- Use simple ASCII punctuation unless a file format requires otherwise.
- Inspect repository instructions and existing changes before editing.
- Preserve unrelated user changes.
- Prefer small, reviewable changes with relevant validation.
- Do not expose credentials, tokens, private keys, or secret file contents.
- Do not perform destructive operations without explicit authorization.
- Do not create or leave a pull request in draft state unless the user
  explicitly requests a draft. If the work is not ready for review, stop
  before opening the pull request and report the blockers. When authorized to
  publish completed work, open a ready-for-review pull request or mark the
  existing draft ready for review.
- Use subagents only when the user or applicable `AGENTS.md` or skill
  instructions explicitly request subagents, delegation, or parallel agent
  work.
- When the Superpowers plugin is installed, skip its full development
  methodology for trivial, low-risk edits. Use the relevant workflow for
  non-trivial features, debugging, planning, and review work.
- Treat explicit user stop points as hard boundaries. Stop at the requested
  milestone and wait before starting the next phase.

## Task interpretation

- Match the requested action mode. `Inspect`, `review`, `diagnose`, and `report`
  authorize investigation and reporting, not implementation. `Fix`, `update`,
  `address`, and `implement` authorize completing the requested change and
  relevant validation.
- Treat an explicit sequence of actions as one authorized workflow. Complete
  every named step without pausing for repeated confirmation unless blocked or
  a new materially risky choice is required.
- Commit, push, pull-request, merge, release, deployment, and external-message
  actions require explicit authorization. When authorized, complete them rather
  than returning instructions or status only.
- When asked to check logs for other issues, inspect the complete relevant run,
  not only the first reported symptom. Separate benign or idempotent conditions
  from genuine failures.
- Never report full success when a required operation, test, validation, or
  requested step failed. Report partial completion and the exact remaining
  blockers.

## Acceptance evidence

- Treat user-provided screenshots and runtime observations as acceptance
  evidence. Reconcile visible failures even when automated checks pass, then
  revalidate.
- When setting up a development environment, install the required tooling and
  prove the actual build, lint, and test commands work on that machine.
- Preserve user-supplied publication-ready commands, links, examples,
  verification steps, and update procedures unless the user asks to condense
  them.

## Scope selection

- Use `AGENTS.md` for durable repository conventions.
- Use `.codex/config.toml` for trusted project-specific Codex settings.
- Use skills for reusable task workflows.
- Always use the `youtube-thumbnail` skill whenever a user mentions a YouTube
  thumbnail or asks to create, edit, review, or improve one.
- Treat files under `docs/` as references, not automatic instructions.
