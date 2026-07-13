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

## Working style

- Use simple ASCII punctuation unless a file format requires otherwise.
- Inspect repository instructions and existing changes before editing.
- Preserve unrelated user changes.
- Prefer small, reviewable changes with relevant validation.
- Do not expose credentials, tokens, private keys, or secret file contents.
- Do not perform destructive operations without explicit authorization.
- Use subagents only when the user or applicable `AGENTS.md` or skill
  instructions explicitly request subagents, delegation, or parallel agent
  work.
- Treat explicit user stop points as hard boundaries. Stop at the requested
  milestone and wait before starting the next phase.

## Scope selection

- Use `AGENTS.md` for durable repository conventions.
- Use `.codex/config.toml` for trusted project-specific Codex settings.
- Use skills for reusable task workflows.
- Treat files under `docs/` as references, not automatic instructions.
